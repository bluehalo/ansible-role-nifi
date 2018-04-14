#!/bin/bash
# $1 nifi_data_dir
# $2 password type: keyStorePassword, trustStorePassword
echo $(awk  'BEGIN{FS="\""}{print $4}' <<< "$(cat $1 |grep $2)")