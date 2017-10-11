#!/bin/bash

echo Finnair cloning and symbolic link script
echo What folder name would you like?
read folder_name
cd ~
mkdir $folder_name 
cd $folder_name
echo Cloning into $folder_name...
# hg clone /mercurial/ay_cas_user_dev.hg
hg clone /mercurial/ay_cms_user_dev.hg
echo Cloning done!
echo Checking Mercurial config
if ! grep -q "[ui]" ~/.hgrc; then
    echo [ui] >> ~/.hgrc
fi
echo State your first and last name...
read name
old_usr=false
if grep -iq "$name" ~/.hgrc; then
    grep -i "$name" ~/.hgrc
    echo "exists, is this correct? (y/n)"
    read resp
    if [ $resp == "y" ]; then
        old_usr=true
    fi
fi
if ! $old_usr; then
    echo State your email-adress...
    read email_adr
    echo Adding $name with email $email_adr
    echo  "username = $name <$email_adr>" >> ~/.hgrc
fi 
echo Mercurial done!
cd ay_cms_user_dev.hg
echo "What is your username? (ex.adamla)"
read usnam
file=etc/users/HIQ/administrators_dev.xml
roles="<user name=$usnam fullname=$name>\n<role>Administrator</role>\n<role>Tracking</role>\n<role>NORRA-Training</role>\n<role>NORRA-Planning</role>\n<role>NORRA-Tracking</role>\n<role>NORRA-Administrator</role>\n<role>NORRA-PostPlanning</role>\n<role>NORRA-PayrollOffice</role>\n<role>NORRA-Viewer</role>\n<role>Planning</role>\n<role>Tracking</role>\n<role>PayrollOffice</role>\n<role>PostPlanning</role>\n<role>Training</role>\n<role>Viewer</role>\n</user>"
if ! grep -q $usnam $file; then
    echo Adding user info to administrators_dev.xml...
    sed -i '0|</users>|i${roles}|' $file
fi
