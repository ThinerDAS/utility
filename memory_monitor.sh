#!/bin/bash

#Minimum available memory limit, MB
THRESHOLD1=1024

THRESHOLD2=2048

#Check time interval, sec
INTERVAL=10

ITERATOR=0

while :
do
    free=$(free -m|awk '/^Mem:/{print $4}')
    buffers=$(free -m|awk '/^Mem:/{print $6}')
    #cached=$(free -m|awk '/^Mem:/{print $7}')
    available=$(free -m | awk '/^Mem:/{print $7}')

    message="Free $free""MB""\nBuffers/cached $buffers""MB""\nAvailable $available""MB"""

    if [ $available -lt $THRESHOLD1 ]
    then
        ### MODIFY THIS NOTIFICATION METHOD FOR YOUR OS 
        notify-send -u critical -i error "$available""MB available, Critical Low Memory Warning" "The computer will lag greatly before you close some program!\n""$message"
        ITERATOR=0
    else

        if [ $available -lt $THRESHOLD2 ]
        then
            ### MODIFY THIS NOTIFICATION METHOD FOR YOUR OS 
            if [ $ITERATOR -eq 0 ]
            then
                notify-send -u critical -i info "$available""MB available, Low Memory Warning" "Take action before the memory gets too low.\n""$message"
            fi
            ((ITERATOR++))
            if [ $ITERATOR -ge 8 ]
            then
                ITERATOR=0
            fi
        else
            ITERATOR=0
        fi
    fi

    echo $message

    sleep $INTERVAL

done

