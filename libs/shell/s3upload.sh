#!/bin/bash
# Call this script with at least 3 parameters, for example
# sh scriptname <release-tag> <deployable-package's path> <upload package format>
#eg: sh scriptname Rel_1.5.0-dev /home/user/app/build/package.deb deb
USER_HOME=$(eval echo ~${SUDO_USER})

#AWS upload directory path
aws_directory="s3://pearson-nibiru-storage-stg/11/brix/brix-upload/"

# Check AWS-CLI installation and if not found then install
(aws --version)||(

# Create temporary installation directory(outside the workspace)
cd  ..
mkdir aws_install && cd aws_install
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws

# Set AWS credential file
mkdir -p ${USER_HOME}/.aws

# AWS credentials
aws_access_key_id="#KEY_ID"
aws_secret_access_key="#SCRT_ID"

# Generate AWS credentials file
cat > ${USER_HOME}/.aws/credentials << EOF1
[default]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key
EOF1

# Remove temporary installation directory
cd .. && rm -rf aws_install

)

# Upload to S3 bucket using AWS CLI
aws s3 cp $2 $aws_directory$1"."$3
