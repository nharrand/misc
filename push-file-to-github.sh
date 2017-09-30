#!/bin/bash
# script to push a file to github via the REST API
#
# requirements:
# "curl", "jq" available (aptitude install jq)
# the file must already exists on the target github repo
#
# to update it:
# push-file-to-github.sh push-file-to-github.sh monperrus misc
#
# URL: https://github.com/monperrus/misc/blob/master/push-file-to-github.sh
# Author: Martin Monperrus
# September 2018

FILE=$1

if [[ ! -z $2 ]];
then
  username=$2
else
  username=SpoonLabs
fi

if [[ ! -z $3 ]];
then
  repo=$3
else
  repo=spoon-incubator
fi

if [[ ! -z $4 ]];
then
  branch=$4
else
  branch=master
fi

if [[ ! -z $5 ]];
then
  # default to environment variable
  TOKEN=$5
else
  TOKEN=$GITHUB_AUTH_TOKEN
fi


echo "https://api.github.com/repos/$username/$repo/contents/$FILE?ref=$branch"
sha=$(curl -X GET "https://api.github.com/repos/$username/$repo/contents/$FILE?ref=$branch" | jq .sha)
echo $TOKEN
curl -X PUT -H "Authorization: token $TOKEN" -d "{\
\"message\": \"update\", \"content\": \"$(openssl base64 -A -in $FILE)\", \"branch\": \"$branch\",\
\"sha\": $sha}" \
https://api.github.com/repos/$username/$repo/contents/$FILE

