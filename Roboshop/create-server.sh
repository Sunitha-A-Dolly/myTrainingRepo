#!/bin/bash

# Create server
# Route53 to create record and configure dns

# Get AMI Id
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=CloudDevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/\"//g')
echo $AMI_ID

# Get Component as Argument
Component=$1

# Get Private IP
PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${Component}}]" --security-group-ids sg-02d54b5554e44973b | jq '.Instances[].PrivateIpAddress' | sed -e 's/\"//g')
echo $PRIVATE_IP

sed -e "/s/IPADDRESS/$PRIVATE_IP/" -e "/s/COMPONENT/$Component/" route53.json > /tmp/record.json

# Create route53 record
aws route53 change-resource-record-sets --hosted-zone-id Z03158041QD430SCB65LE --change-batch file:///tmp/record.json | jq

