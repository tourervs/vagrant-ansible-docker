#!/bin/bash
if ! rpm -q --quiet epel-release-6-8 ; then 
  rpm -i https://mirror.yandex.ru/epel/6/x86_64/epel-release-6-8.noarch.rpm  
fi
yum repolist
yum install ansible -y
