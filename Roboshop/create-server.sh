#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=CloudDevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/\"//g')
echo $AMI_ID
Component=$1
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${Component}}]" --security-group-ids sg-02d54b5554e44973b | jq