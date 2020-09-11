#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for looking up EIDs from an ASURITE ID\n\n"

read -p "Affiliate First Name: " fname

read -p "Affiliate Last Name: " lname

eid=$(lynx -source https://asudir-solr.asu.edu/asudir/directory/select?q=firstName:$fname%20AND%20lastName:$lname | sed -r 's/\<[a-z]+>/&\n/g' | grep eid | sed 's/<str name="eid">//' | sed 's\</str>\\')

printf "EID: \e[1m\e[36m$eid\n"
printf "\n"
