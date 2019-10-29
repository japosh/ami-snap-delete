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
echo -e "$1" > /tmp/image-names.txt

aws ec2 describe-images --owners self --filters Name=name,Values=`cat /tmp/image-names.txt` > /tmp/output_describe.txt

#Find images matching with the parameter passed
cat /tmp/output_describe.txt | grep '"Name' | awk -F : '{ print $2 }' | sed 's/"//g' > /tmp/image-names.txt

#Find snapshots associated based on the match images
cat /tmp/output_describe.txt | grep 'SnapshotId' | awk -F : '{ print $2 }' | sed 's/"//g;s/,//g' > /tmp/snaps.txt

#Filter and save AMI's IDs to be deleted
cat /tmp/output_describe.txt | grep 'ImageId' | awk -F : '{ print $2 }' | sed 's/"//g;s/,//g' > /tmp/image-ids.txt

#Print on screen the results of search
echo -e "Images and snapshots found:\n\nImages:\n`cat /tmp/image-names.txt`\n\n Snapshots:\n`cat /tmp/snaps.txt` \n"

#Conditional to proceed
read -p "Do you want to continue? [y/n] " -r

echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

#Start the deregister of AMIs
echo -e "Deregistering the AMIs... \n"

for id in `cat /tmp/image-ids.txt`
do aws ec2 deregister-image --image-id $id ;
done

#Delete the associated snapshots
echo -e "\nDeleting associated snapshots.... \n"

for snap in `cat /tmp/snaps.txt`
do aws ec2 delete-snapshot --snapshot-id $snap ;
done

echo -e "\n\nImages and snapshots successfully removed of your account!"

rm -f /tmp/output_describe.txt /tmp/image-names.txt /tmp/snaps.txt /tmp/image-ids.txt
