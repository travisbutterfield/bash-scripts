#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for looking up ASURITE IDs from a .csv file on your computer\n\n"

printf "Please prepare a .csv file with two columns: 'FirstName' and 'LastName'\n\n"

#Must use full path without tilde or $HOME variable to work
IFS= read -r -p "Enter the full path to the file you have prepared: " path

printf "You will get a new .csv file with the ASURITE IDs in your Home directory named 'asurite-ids-output.csv'\n\n"

printf "Please wait while I process the file.\n\n"



cat "$path" | while IFS=, read -r FirstName LastName
do
  asuriteId=$(lynx -dump https://asudir-solr.asu.edu/asudir/directory/select?q=firstName:$FirstName%20AND%20lastName:$LastName | sed -E 's/\<str>/&\n/g' | grep asuriteId | sed 's/<str name="asuriteId">//' | sed 's\</str>\\')
  echo $FirstName $LastName,$asuriteId >> ~/asurite-ids-output.csv
done
