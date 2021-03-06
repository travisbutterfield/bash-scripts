#!/bin/bash

printf "\nHello!\n\nLook up an ASURITE ID by iSearch EID!\n\n"

read -p "Affiliate's EID: " eid

asuriteId=$(lynx -source https://asudir-solr.asu.edu/asudir/directory/select?q=eid:$eid | sed -E 's/\<str>/&\n/g' | grep asuriteId | sed 's/<str name="asuriteId">//' | sed 's\</str>\\')

printf "ASURITE ID: \e[1m\e[36m$asuriteId\n"
printf "\n"

# cat ~/Desktop/bash\ scripts/email-list.txt | while read email
# do
#   asuriteId=$(lynx -dump https://asudir-solr.asu.edu/asudir/directory/select?q=emailAddress:$email | sed -E 's/\<str>/&\n/g' | grep asuriteId | sed 's/<str name="asuriteId">//' | sed 's\</str>\\')
#   echo $email,$asuriteId >> ./output.csv
# done
