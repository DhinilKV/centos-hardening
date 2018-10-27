#!/bin/bash

> /tmp/result.txt
echo "Software Updates" >> /tmp/result.txt
echo "++++++++++++++++" >> /tmp/result.txt


#Ensure GPG keys are configured
grep ^gpgcheck /etc/yum.conf | grep "1" > /dev/null 2>&1
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 GPG keys are configured" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C Keys are not configured" >> /tmp/result.txt
fi

#Ensure GPG keys are configured
echo " " >> /tmp/result.txt
echo "# list of GPG keys" >> /tmp/result.txt
rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' >> /tmp/result.txt

echo " " >> /tmp/result.txt
echo "Additional Process Hardening" >> /tmp/result.txt ; echo "++++++++++++++++++++++++" >> /tmp/result.txt

#Ensure core dumps are restricted
echo " " >> /tmp/result.txt
grep "hard core" /etc/security/limits.conf /etc/security/limits.d/* > /dev/null 2>&1
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 Core Dumps are configured" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C Core Dumps are not configured" >> /tmp/result.txt
fi

#Ensure XD/NX support is enabled
echo " " >> /tmp/result.txt
dmesg | grep NX > /dev/null
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 XD/NX support is enabled" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C XD/NX support is disabled" >> /tmp/result.txt
fi


#Ensure address space layout randomization (ASLR) is enabled
echo " " >> /tmp/result.txt
grep "kernel.randomize_va_space" /etc/sysctl.conf | grep "2" > /dev/null 2>&1
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 address space layout randomization (ASLR) is enabled" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C address space layout randomization (ASLR) is disabled" >> /tmp/result.txt
fi

#Ensure prelink is disabled 
echo " " >> /tmp/result.txt
rpm -q prelink | grep "not installed" > /dev/null 2>&1
if [ $? == 1 ] ; then
echo -e "\xE2\x9C\x94 prelink is disabled" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C prelink is enabled" >> /tmp/result.txt
fi

#Secure Boot Settings
echo " " >> /tmp/result.txt
echo "Secure Boot settings" >> /tmp/result.txt ; echo "+++++++++++++" >> /tmp/result.txt
stat /boot/grub2/grub.cfg | grep 600 > /dev/null 2>&1
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 permissions on bootloader config are configured" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C permissions on bootloader config are not configured" >> /tmp/result.txt
fi

#Warning Banners
echo " " >> /tmp/result.txt
echo "Warning Banners" >> /tmp/result.txt
echo "+++++++++++++++" >> /tmp/result.txt
echo " " >> /tmp/result.txt
cat /etc/motd | egrep '(\\v|\\r|\\m|\\s)' > /dev/null 2>&1
if [ $? == 1 ] ; then
echo -e "\xE2\x9C\x94 message of the day is configured properly" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C message of the day is not configured properly" >> /tmp/result.txt
fi

#Ensure local login warning banner is configured properly 
echo " " >> /tmp/result.txt
cat /etc/issue | egrep '(\\v|\\r|\\m|\\s)' > /dev/null 2>&1
if [ $? == 1 ] ; then
echo -e "\xE2\x9C\x94 local login warning banner is configured properly" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C local login warning banner is not configured properly" >> /tmp/result.txt
fi

#Ensure permissions on /etc/motd are configured 
echo " " >> /tmp/result.txt
stat /etc/motd | grep 644 > /dev/null 2>&1
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 permissions on /etc/motd are configured" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C permissions on /etc/motd are not configured" >> /tmp/result.txt
fi

#Ensure permissions on /etc/issue are configured
echo " " >> /tmp/result.txt
stat /etc/issue | grep 644 > /dev/null 2>&1
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 permissions on /etc/isssue are configured" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C permissions on /etc/issue are not configured" >> /tmp/result.txt
fi


#Services 
echo " " >> /tmp/result.txt
echo "Inetd Services" >> /tmp/result.txt
echo " ++++++++++++" >> /tmp/result.txt
chkconfig --list > /tmp/chkconfig.txt 
cat /tmp/chkconfig.txt | grep "chargen" | grep -i off 
if [ $? == 0 ] ; then
echo -e "\xE2\x9C\x94 chargen services are not enabled" >> /tmp/result.txt
else
echo -e "\xE2\x9D\x8C chargen services are enabled" >> /tmp/result.txt
fi
