#!/bin/bash
HOSTNAME=$(cat /boot/firstboot.txt | grep hostname= | tr -d hostname=)
PASSWORD=$(cat /boot/firstboot.txt | grep rootpass= | tr -d rootpass=)
SSHPORT=$(cat /boot/firstboot.txt | grep sshport= | tr -d sshport=)

#change root password
passwd root<<EOF
$PASSWORD
$PASSWORD
EOF

passwd pi<<EOF
$PASSWORD
$PASSWORD
EOF

#change hostname
echo $HOSTNAME > /etc/hostname
sed -i 's/raspberrypi/$HOSTNAME/g' /etc/hosts

#change dns
echo nameserver 180.76.76.76 > /etc/resolv.conf

#enable ssh root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl enable ssh

#change ssh port
sed -i 's/#Port 22/Port $SSHPORT/g' /etc/ssh/sshd_config

#change software repositories
echo  > /etc/apt/sources.list
echo  > /etc/apt/sources.list.d/raspi.list
cat>>/etc/apt/sources.list<<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi
deb-src http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi
EOF

cat>>/etc/apt/sources.list.d/raspi.list<<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui
EOF

#Reboot
mv /etc/raspi-firstboot.sh /etc/firstboot.sh.bak
reboot
