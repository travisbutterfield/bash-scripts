#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for looking up a name from an ASURITE IDs\n\n"

read -p "ASURITE ID: " asurite

displayname=$(lynx -source https://asudir-solr.asu.edu/asudir/directory/select?q=asuriteId:$asurite | sed -E 's/\<str>/&\n/g' | grep displayName | sed 's/<str name="displayName">//' | sed 's\</str>\\')

printf "Name: \e[1m\e[36m$displayname\n"
printf "\n"
