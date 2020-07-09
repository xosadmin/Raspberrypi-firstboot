This is a repository that related to my blog post, which is about Raspberry Pi first boot. This bash file is good for users that configurating Raspberry Pi without monitor.   
Original blog post (Chinese):   
Download modified firmware:   

Usage:   
1. Flash Raspbian into your SD card  
2. Before plug SD card into Raspberrypi, place bash file "raspi-firstboot.sh" into Rootfs partition, and create firstboot.txt at the root of Boot partition.  
3. Add "sh /path/to/raspi-firstboot.sh" into /etc/rc.local  
4. Give permission for /etc/rc.local and this bash file  
5. Enjoy  
