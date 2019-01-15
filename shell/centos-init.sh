#!/usr/bin/env bash

yum install -y wget
#Centos7 关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service


# 安装jdk
set -e
#wget --no-cookie --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz
tar xzvf $(basename $(find -name "jdk*"))
jdk_dir_name=$(basename $(find . -maxdepth 1 -name "jdk*" -type d ))
sudo mv ${jdk_dir_name} /usr/local
#export JAVA_HOME=/usr/local/${jdk_dir_name}
echo "export JAVA_HOME=/usr/local/jdk1.8.0_162
export PATH=\$JAVA_HOME/bin:\$PATH:\$HOME/bin
export CLASSPATH=.:\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib" | sudo tee --append /etc/profile > /dev/null

source ${HOME}/.bash_profile
java -version

#上面保存为install.sh 文件
for k in $( seq 2 6 )
do
    scp -P 1715 .bash_profile dw.cloud${k}:~
#    ssh -p1715 dw.cloud${k} "sudo bash install.sh"
done



## 免密码登陆
mkdir .ssh
chmod 700 .ssh
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDtXuVFkoY7pS0rg44BjAxvDaXNKmN4TiUX2ywO/2FCik6RDt+DxF/eCLVRkDtGEwZBn1a9CoqcwWmzyYQ6C5vkKKhELS3/y79yGwns1JeN7HY6NvTSTat\
Ja60scuJFXOUnPRccGN/snwR8ylhguPJV0O93oJ8OX1fPSZnEFvY5zwlBzEYf+/yil+ruBwtBs4D8Yq8h60Ib7y2VGIGLC0ikl6ezsDB7kEOmI4nJtnNiqhi1UiIj53skdqSW2pi+fdVMY9r2BdxJm2yznnP/CVxGPw49\
+OvTaxD/i//mGjzWhb8qq0ip2t9Zvr7DYWnYlNsycGNQ/AvH6bqF2HPixUt1 tommy@LAPTOP-OL04TGLP" >> .ssh/authorized_keys

echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0HJcBFMy7u5k2a6JxDs8vuECodpcfSwfDN/vlOwVi4geTRLqp4fc3yDbMLEqlr/1i36z4rzNPNoT3BuWxq37+USjDe9ScyUldSPjpxgVX4J3De/eEZiEl8u8hMs2K\
4d2Js4x+FvHgOj/Hzocfoc417HjlbqOsIumy+Q/+x6tTHku38eT0GambECUlpQOhWvJYsJIMtVPPj2lo8FZ0bn5g7l8FV2KuZ/4s6EzAyC+rvuGVgqSwDeRXD8lBWMZokonFlwDkGOFsZ5eudnvduLsQnWW/Q8HG1g+X2y63\
ESZv6GteggdxS0N7NA7FdBTUjtBQgaZcw/WtDUbhApZZ7/QkQ== jiaqi1.xu@iZ2ze23w0nyvm45m849u95Z" >> .ssh/authorized_keys

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCx/1bQmyESzJRRZqo91H4/SMbrTOVCilNbvr8mlZ2D+BrSjPTDoaBISiR062d2+wioPfXVWqMWb7azk/TN2tq6I9ph5ZztWmZDRPMFa3kztTlHkt+EKcUqWL5\
F4rA5DsnKaZ/uyPzjEGhe2KiyEnXtqWl4iw44K7zJ2GY4Yqh8jt3T8Q091FB8VZfP+Ze3ml9G4S4AvHsQerFFlod987xIDQ3lJywlTcZXlsd65ujw1svPdLbXZWtd20equ9f4f0yZS27YpZKqp+eXSToge9CQ2GziXTP3\
JfXiJmLeYlFp318ANJ2+qnD06/fxv229uv4pNxCCK7Bw1eU9Xd40O4Kz xuchao2@100tal.com" >> .ssh/authorized_keys

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7BTdbDFC9+gneaI60cUTf44j22+a+DmH0PU8fUGK7uDZe+LVMESISiQQD2OEDa+Aak3QMYXEeG3k0y1XFzpYTNZvpkas9TygaF6mGrdJPs8lv1wF9uPDrfGSL\
9sfFf4YutD1bqn6i85kpDniO/tDJVAbMVKUIsvroVRUoC40+L50LG9NDfUaTARAdvIa0DqerIAoI424jzTJFKlqEVbXhPyLjTglEBZwRvkxvhusn4Wuz3umr9YMFCA8IPpXyTSkMEtzU7DNPa9nTcPkt4oJxokxf9uYHECk\
tC02RRhLZWOv9V5DxDCaEhPijDDSm+JOTXbcv+S/zKgGXl6Zw6bQP Administrator@wpf-pc" >> .ssh/authorized_keys


## 修改host
sudo sh -c "echo '
192.168.150.71 dw.cloud1
192.168.150.72 dw.cloud2
192.168.150.73 dw.cloud3
192.168.150.74 dw.cloud4
192.168.150.75 dw.cloud5
192.168.150.76 dw.cloud6
' >> /etc/hosts "