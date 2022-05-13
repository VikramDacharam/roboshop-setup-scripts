#!/usr/bin/env bash

if [ -z "$1" ]; then

  echo "instance name as argument is needed"
fi

NAME=$1


AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" --output table | grep ImageId | awk '{print $4}')

aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${NAME}}]" "ResourceType=instances,Tags=[{Key=Name,Value=${NAME}}]"

