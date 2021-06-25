#! /bin/bash
# set your high temperature here. this server returns the temps in °F you can change to °C by removing the '-f' from sensors on line 10 and 11
ht=139
# set your catastrophic temperature here
ct=169
# set your email here, mine mails locally
email=administrator
# change this to your home directory, or where you want them. They're basically temp files.
tdir=/home/administrator # no final / - it could cause issues

# This file is to check the temperature of CPU0 and email the admin if it's too high
# I set the temperatures at a conservative 139 and 169. I've not seen the temps this high.
# Written by Dave the Pear - Lazy Admin

# This checks Core 0 
tc=$(echo `sensors -f | grep Core\ 0 | awk '{ print int($3) }'`)
tcc=$(echo `sensors -f | grep Core\ 0 | awk '{ print $3 }'`)
# if the temp is 160 or higher, it will continuously nag
if [ "$tc" -gt "$ct" ]; then
    touch $tdir/.nagmail/TemperatureMailed
    printf "CPU temperature is now at $tcc! \nThis is NOT GOOD! \nIf you don't hear from me again in a few minutes, I am either cooled down or shut down. \n Do something!" | mail -s "SERVER TEMPERATURE EXTREMELY HIGH!" $email
   exit 1
fi
# if it's below 160 - continue
file=$tdir/.nagmail/TemperatureMailed
fileagain=$tdir/.nagmail/TemperatureMailedAgain
clear=$tdir/.nagmail/TemperatureClear

# You've been emailed once, this will skip the next check 2 mins later
if [ -f "$file" ]; then
    rm $tdir/.nagmail/TemperatureMailed
    touch $tdir/.nagmail/TemperatureMailedAgain
    exit 1
fi

# Skipping the 4 minute check You will be mailed again soon if temp still high.
if [ -f "$fileagain" ]; then
    rm $tdir/.nagmail/TemperatureMailedAgain
    touch $tdir/.nagmail/TemperatureClear
    exit 1
fi

# this is to start the nagging again
if [ -f "$clear" ]; then
    rm $tdir/.nagmail/*
fi

# echo Email sent if over 140 but less than 160
if [ "$tc" -gt "$ht" ]; then
    touch $tdir/.nagmail/TemperatureMailed
    printf "CPU temperature is now at $tcc! \nMaybe consider some air conditioning? Maybe a fan has failed, idk I'm just a stupid server!\n\nI will nag you again in about 6 minutes, unless it gets really hot.\nIf you don't hear from me, I am either cooled down or shut down." | mail -s "Server temperature!" administrator
else
    touch $tdir/.nagmail/*
    exit 1
fi
