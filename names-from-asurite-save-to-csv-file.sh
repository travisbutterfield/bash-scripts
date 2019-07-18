#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script using a .txt file \n
on your computer to look up names from ASURITE IDs\n\n"

printf "Please prepare a .txt file with ASURITE IDs one-per-line\n\n"

#Must use full path without tilde or $HOME variable to work
IFS= read -r -p "Enter the full path to the file you have prepared: " path

printf "You will get a new .csv file with the desired names in your Home directory named 'names-output.csv'\n\n"

printf "Please wait while I process the file.\n\n"


cat "$path" | while read asurite
do
  displayname=$(lynx -dump https://asudir-solr.asu.edu/asudir/directory/select?q=asuriteId:$asurite | sed -E 's/\<str>/&\n/g' | grep displayName | sed 's/<str name="displayName">//' | sed 's\</str>\\')
  echo $asurite,$displayname >> ~/names-output.csv
done
