#!/bin/bash

# Set the AWS region to us-west-2 for all AWS CLI commands
AWS_REGION="us-west-2"

# Wait for 'mc' utility to be installed.
while ! [ -f "/usr/local/bin/mc" ]; do
	echo "'mc' not here"
	sleep 1;
done;

# Retrieve the public IP address for each MinIO instance
MINIO1=$(aws ec2 describe-instances --region "$AWS_REGION" \
    --filters "Name=tag:Name,Values=minio-us-west-2-cluster1-1" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

MINIO2=$(aws ec2 describe-instances --region "$AWS_REGION" \
    --filters "Name=tag:Name,Values=minio-us-west-2-cluster2-1" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

MINIO3=$(aws ec2 describe-instances --region "$AWS_REGION" \
    --filters "Name=tag:Name,Values=minio-us-west-2-cluster3-1" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

# Wait for 'minio' utility to be installed.
while ! [ -f "/usr/local/bin/minio" ]; do
	echo "'minio' not here"
	sleep 1;
done;

# Ensure script is finished
while ! tail -n 1 /var/log/cloud-init-output.log | grep -q 'finished'; do
    echo "Bootstrap not finished"
    sleep 1
done

echo "Bootstrap finished"

# Set the minio aliases using the 'mc alias set' command.
mc alias set minio1 http://$MINIO1:9000 miniominio miniominio
mc alias set minio2 http://$MINIO2:9000 miniominio miniominio
mc alias set minio3 http://$MINIO3:9000 miniominio miniominio

# Add the replication configuration using the 'mc admin replicate add' command.
mc admin replicate add minio1 minio2 minio3