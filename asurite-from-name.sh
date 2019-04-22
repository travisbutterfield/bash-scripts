#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for looking up ASURITE IDs\n\n"

read -p "Affiliate First Name: " fname

read -p "Affiliate Last Name: " lname

asuriteId=$(lynx -dump https://asudir-solr.asu.edu/asudir/directory/select?q=firstName:$fname%20AND%20lastName:$lname | sed -E 's/\<str>/&\n/g' | grep asuriteId | sed 's/<str name="asuriteId">//' | sed 's\</str>\\')

printf "ASURITE ID: \e[1m\e[36m$asuriteId\n"
printf "\n"
