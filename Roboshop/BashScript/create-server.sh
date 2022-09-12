#!/bin/bash

# Create server
# Route53 to create record and configure dns

# Get AMI Id
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=CloudDevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/\"//g')
echo $AMI_ID

# Get Component as Argument
if [ $1 == null ] ; then
    echo -n "Enter valid argument all/Component name"
    exit 1
fi
Component=$1
SecurityGroupId='sg-02d54b5554e44973b'
HostedZoneId='Z03158041QD430SCB65LE'



create_server() {

        echo -n " $Component component creation in progress "
        # Get Private IP
        PRIVATE_IP=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${Component}}]" --security-group-ids $SecurityGroupId | jq '.Instances[].PrivateIpAddress' | sed -e 's/\"//g')
        echo $PRIVATE_IP

        # replace ipaddress and component name
        sed -e "s/IPADDRESS/$PRIVATE_IP/" -e "s/COMPONENT/$Component/" route53.json > /tmp/record.json

        # Create route53 record
        aws route53 change-resource-record-sets --hosted-zone-id $HostedZoneId --change-batch file:///tmp/record.json | jq

}
if [ $1 == all ] ; then
    for component in frontend catalogue cart user shipping payment mysql rabbitmq redis mongodb dispatch ; do
      Component=$component
      create_server
    done
else
    create_server
fi

