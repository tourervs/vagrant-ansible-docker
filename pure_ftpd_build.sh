#!/usr/bin/env bash
PUREFTPD_DIR="/opt/pureftpd"
PUREFTPD_LINK="https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.47.tar.gz"
NAME="pure-ftpd"
VERSION="1.0.47"
BUILD_USER="mock"
FTP_USER="ftpusers"
SRC_NAME="pure-ftpd-1.0.47.tar.gz"

yum install wget -y
yum install gcc.x86_64 -y
yum install rpm-build -y

if ! id $BUILD_USER ; then 
  useradd -m $BUILD_USER
fi

mkdir -p /home/$BUILD_USER/rpmbuild
mkdir -p /home/$BUILD_USER/rpmbuild/BUILD /home/$BUILD_USER/rpmbuild/RPMS 
mkdir -p /home/$BUILD_USER/rpmbuild/SOURCES /home/$BUILD_USER/rpmbuild/SPECS 
mkdir -p /home/$BUILD_USER/rpmbuild/SRPMS
chown -R $BUILD_USER:$BUILD_USER /home/$BUILD_USER/rpmbuild
wget -O /home/$BUILD_USER/rpmbuild/SOURCES/pure-ftpd-1.0.47.tar.gz $PUREFTPD_LINK
echo "
Name:           $NAME
Version:        $VERSION
Release:        1%{?dist}
Summary:        Pure-FTPd is a free (BSD), secure, production-quality and standard-conformant FTP server.

License:        Free software (BSD License)
URL:            https://www.pureftpd.org/
Source0:        $SRC_NAME

Requires(post): info
Requires(preun): info

%description
Pure-FTPd is a free (BSD), secure, production-quality and standard-conformant FTP server.

%prep
%setup
%build
./configure --prefix=/usr --with-puredb
make PREFIX=/usr %{?_smp_mflags}
%install
make PREFIX=/usr DESTDIR=%{?buildroot} install

%clean
rm -rf %{buildroot}

%files
%{_bindir}/pure-statsdecode
%{_bindir}/pure-pwconvert
%{_bindir}/pure-pw
%{_sbindir}/pure-authd
%{_sbindir}/pure-ftpd
%{_sbindir}/pure-ftpwho
%{_sbindir}/pure-mrtginfo
%{_sbindir}/pure-quotacheck
%{_sbindir}/pure-uploadscript
%{_sysconfdir}/pure-ftpd.conf
%{_mandir}/man8/*

" > /home/$BUILD_USER/rpmbuild/SPECS/$NAME-$VERSION.spec
sudo -H -u $BUILD_USER bash -c  "rpmbuild -bb /home/$BUILD_USER/rpmbuild/SPECS/$NAME-$VERSION.spec"
rpm -ivh /home/$BUILD_USER/rpmbuild/RPMS/`arch`/$NAME-$VERSION*.rpm

if ! id $FTP_USER ; then
  useradd -m -s /sbin/nologin $FTP_USER
fi

pure-pw mkdb  -F /etc/pureftpd.pdb
sed -i 's/# PureDB                       \/etc\/pureftpd.pdb/PureDB                       \/etc\/pureftpd.pdb/' /etc/pure-ftpd.conf
sed -i 's/# CreateHomeDir                yes/CreateHomeDir                yes/' /etc/pure-ftpd.conf
sed -i 's/Daemonize                    no/Daemonize                    yes/' /etc/pure-ftpd.conf
#
echo -e  "ftpuser\nftpuser" | pure-pw useradd ftpuser -u ftpusers -d /home/ftpusers/ftpuser -m -f /etc/pureftpd.passwd -F /etc/pureftpd.pdb
