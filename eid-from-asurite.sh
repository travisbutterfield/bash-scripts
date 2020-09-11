#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for looking up EIDs from an ASURITE ID\n\n"

read -p "Please enter the ASURITE ID of individual: " asurite

eid=$(lynx -source https://asudir-solr.asu.edu/asudir/directory/select?q=asuriteId:$asurite | sed -r 's/\<[a-z]+>/&\n/g' | grep eid | sed 's/<str name="eid">//' | sed 's\</str>\\')

printf "EID: \e[1m\e[36m$eid\n"
printf "\n"
