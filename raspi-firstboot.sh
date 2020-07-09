#!/bin/bash

#Read Flag
cghostname=$(cat /boot/firstboot.txt | grep change-hostname= | tr -d change-hostname=)
cgrootpass=$(cat /boot/firstboot.txt | grep change-root-password= | tr -d change-root-password=)
cgsshport=$(cat /boot/firstboot.txt | grep change-ssh-port= | tr -d change-ssh-port=)
cgsshroot=$(cat /boot/firstboot.txt | grep enable-root-login-remote= | tr -d enable-root-login-remote=)
cgsoftrepo=$(cat /boot/firstboot.txt | grep change-soft-repo= | tr -d change-soft-repo=)
cgdns=$(cat /boot/firstboot.txt | grep change-dns= | tr -d change-dns=)
enablevnc=$(cat /boot/firstboot.txt | grep enable-vnc= | tr -d enable-vnc=)

#Value Read
HOSTNAME=$(cat /boot/firstboot.txt | grep hostname= | tr -d hostname=)
PASSWORD=$(cat /boot/firstboot.txt | grep rootpass= | tr -d rootpass=)
SSHPORT=$(cat /boot/firstboot.txt | grep sshport= | tr -d sshport=)
DNS=$(cat /boot/firstboot.txt | grep dns= | tr -d dns=)

#change root password
if [ $cgrootpass = "1" ];then
passwd root<<EOF
$PASSWORD
$PASSWORD
EOF

passwd pi<<EOF
$PASSWORD
$PASSWORD
EOF
fi

#change hostname
if [ $cghostname = "1" ];then
	echo $HOSTNAME > /etc/hostname
	sed -i 's/raspberrypi/$HOSTNAME/g' /etc/hosts
else
	echo "Skipped"
fi

#change dns
if [ $cgdns = "1" ];then
	echo nameserver $DNS > /etc/resolv.conf
else
	echo "Skipped"
fi

#enable ssh root login
if [ $cgsshroot = "1" ];then
	sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
	systemctl enable ssh
else
	echo "Skipped"
fi

#change ssh port
if [ $cgsshport = "1" ];then
	sed -i 's/#Port 22/Port $SSHPORT/g' /etc/ssh/sshd_config
else
	echo "Skipped"
fi

#change software repositories
if [ $cgsoftrepo = "1" ];then
echo  > /etc/apt/sources.list
echo  > /etc/apt/sources.list.d/raspi.list
cat>>/etc/apt/sources.list<<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi
deb-src http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi
EOF

cat>>/etc/apt/sources.list.d/raspi.list<<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui
EOF
else
	echo "Skipped"
fi

#enable vnc access
if [ $enablevnc = "1" ];then
	echo "vncserver &" >> /etc/rc.local
else
	echo "Skipped"
fi

#Reboot
mv /etc/raspi-firstboot.sh /etc/firstboot.sh.bak
reboot
