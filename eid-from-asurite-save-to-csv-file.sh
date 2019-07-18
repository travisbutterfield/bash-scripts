#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for looking up EIDs from a .txt file on your computer\n\n"

printf "Please prepare a .txt file with ASURITE IDs one-per-line\n\n"

#Must use full path without tilde or $HOME variable to work
IFS= read -r -p "Enter the full path to the file you have prepared: " path

printf "You will get a new .csv file with the EIDs in your Home directory named 'eid-output.csv'\n\n"

printf "Please wait while I process the file.\n\n"


cat "$path" | while read asurite
do
  eid=$(lynx -dump https://asudir-solr.asu.edu/asudir/directory/select?q=asuriteId:$asurite | sed -r 's/\<[a-z]+>/&\n/g' | grep eid | sed 's/<str name="eid">//' | sed 's\</str>\\')
  echo $asurite,$eid >> ~/eid-output.csv
done
