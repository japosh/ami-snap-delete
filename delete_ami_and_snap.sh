#!/bin/bash

#===============================================================================#
#title           :delete_images.sh
#description     :This script search for AMIs and their respective snapshots, list them and you can deregister and delete the snapshots automatically.
#author          :Lucas Oshiro | lucas.oshiro@hotmail.com | [https://goo.gl/oNNt2S]
#date            :20170924
#version         :2.2
#usage           :bash delete_images.sh <parameter>
#notes           :AWS-CLI is needed to use this script.
#===============================================================================#


#Take input of AMI name to be deleted (full-name or term to match [ex. image_2017-*]
echo -e "$1" > /tmp/image-name.txt

aws ec2 describe-images --filters Name=name,Values=`cat /tmp/image-name.txt` > /tmp/output_describe.txt

#Find image(s) matching with the parameter passed
cat /tmp/output_describe.txt | grep '"Name' | awk -F : '{ print $2 }' | sed 's/"//g' > /tmp/images.txt

#Find snapshot(s) associated based on the match images
cat /tmp/output_describe.txt | grep 'SnapshotId' | awk -F : '{ print $2 }' | sed 's/"//g' > /tmp/snap.txt

#Print on screen the results of search
echo -e "Images and snapshots found:\n\nImages:\n`cat /tmp/images.txt`\n\n Snapshots:\n`cat /tmp/snap.txt` \n"

#Conditional to proceed
read -p "Do you want to continue? [y/n] " -r

echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

#Start the deregister of AMIs
echo -e "Deregistering the AMIs... \n"

for image in `cat /tmp/images.txt`
do aws ec2 deregister-image --image-id $image ;
done

#Delete the associated snapshots
echo -e "\nDeleting associated snapshots.... \n"

for snap in `cat /tmp/snap.txt`
do aws ec2 delete-snapshot --snapshot-id $snap ;
done

echo -e "\n\nImages and snapshots successfully removed of your account!"
