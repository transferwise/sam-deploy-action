#!/bin/bash

set -e

if [[ -z "$TEMPLATE" ]]; then
    echo "Empty template specified. Looking for template.yaml..."

    if [[ ! -f "template.yaml" ]]; then
        echo template.yaml not found
        exit 1
    fi

    TEMPLATE="template.yaml"
fi

if [[ -z "$AWS_STACK_NAME" ]]; then
    echo AWS Stack Name invalid
    exit 1
fi

if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    echo AWS Access Key ID invalid
    exit 1
fi

if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo AWS Secret Access Key invalid
    exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
    echo AWS Region invalid
    exit 1
fi

if [[ -z "$AWS_DEPLOY_BUCKET" ]]; then
    echo AWS Deploy Bucket invalid
    exit 1
fi

if [[ ! -z "$AWS_BUCKET_PREFIX" ]]; then
    AWS_BUCKET_PREFIX="--s3-prefix ${AWS_BUCKET_PREFIX}"
fi

if [[ ! -z "$AWS_SIGNING_PROFILES" ]]; then
    AWS_SIGNING_PROFILES="--signing-profiles ${AWS_SIGNING_PROFILES}"
fi

if [[ $FORCE_UPLOAD == true ]]; then
    FORCE_UPLOAD="--force-upload"
fi

if [[ $USE_JSON == true ]]; then
    USE_JSON="--use-json"
fi

if [[ -z "$CAPABILITIES" ]]; then
    CAPABILITIES="--capabilities CAPABILITY_IAM"
else
    CAPABILITIES="--capabilities $CAPABILITIES"
fi

if [[ ! -z "$PARAMETER_OVERRIDES" ]]; then
    PARAMETER_OVERRIDES="--parameter-overrides $PARAMETER_OVERRIDES"
fi

if [[ ! -z "$TAGS" ]]; then
    TAGS="--tags $TAGS"
fi

mkdir ~/.aws
touch ~/.aws/credentials
touch ~/.aws/config

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
region = $AWS_REGION" > ~/.aws/credentials

echo "[default]
output = text
region = $AWS_REGION" > ~/.aws/config

sam build
sam deploy --template-file $TEMPLATE --region $AWS_REGION --stack-name $AWS_STACK_NAME --s3-bucket $AWS_DEPLOY_BUCKET $AWS_BUCKET_PREFIX $AWS_SIGNING_PROFILES $CAPABILITIES $FORCE_UPLOAD
