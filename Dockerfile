FROM centos:6.9

RUN /usr/bin/yum update -y
RUN /usr/bin/yum install openssh-server -y
RUN /usr/bin/yum install openssh-clients -y
RUN /usr/bin/yum install sudo -y
#RUN /usr/bin/yum install wget -y
#RUN /usr/bin/yum install gcc.x86_64 -y
#RUN /usr/bin/yum install rpm-build -y
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/' /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
RUN /usr/bin/ssh-keygen -t dsa -N "" -f /etc/ssh/ssh_host_dsa_key
RUN echo "pureftpd123" | passwd root --stdin

# SSH login fix. Otherwise user is kicked off after login
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo -e "#!/bin/bash\nif [ -f /usr/sbin/pure-ftpd ]; then  /usr/sbin/pure-ftpd /etc/pure-ftpd.conf ; /usr/sbin/sshd -e -D  ;  else /usr/sbin/sshd -e -D ; fi" > /var/up.sh
RUN chmod +x /var/up.sh


EXPOSE 22
EXPOSE 21
CMD ["/var/up.sh"]
#CMD ["/usr/sbin/sshd","-e","-D"]
