#!/bin/bash

printf "\nHello!\n\nLook up a Display Name by iSearch EID!\n\n"

read -p "Affiliate's EID: " eid

displayName=$(lynx -source https://asudir-solr.asu.edu/asudir/directory/select?q=eid:$eid | sed -E 's/\<str>/&\n/g' | grep displayName | sed 's/<str name="displayName">//' | sed 's\</str>\\')

printf "Display Name: \e[1m\e[36m$displayName\n"
printf "\n"

# cat ~/Desktop/bash\ scripts/email-list.txt | while read email
# do
#   asuriteId=$(lynx -dump https://asudir-solr.asu.edu/asudir/directory/select?q=emailAddress:$email | sed -E 's/\<str>/&\n/g' | grep asuriteId | sed 's/<str name="asuriteId">//' | sed 's\</str>\\')
#   echo $email,$asuriteId >> ./output.csv
# done
