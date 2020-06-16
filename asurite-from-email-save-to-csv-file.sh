#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for looking up ASURITE IDs from a .txt file on your computer\n\n"

printf "Please prepare a .txt file with ASU email addresses one-per-line\n\n"

#Must use full path without tilde or $HOME variable to work
IFS= read -r -p "Enter the full path to the file you have prepared: " path

printf "You will get a new .csv file with the ASURITE IDs in your Home directory named 'output.csv'\n\n"

printf "Please wait while I process the file.\n\n"


cat "$path" | while read email
do
  asuriteId=$(lynx -source https://asudir-solr.asu.edu/asudir/directory/select?q=emailAddress:$email | sed -E 's/\<str>/&\n/g' | grep asuriteId | sed 's/<str name="asuriteId">//' | sed 's\</str>\\')
  echo $email,$asuriteId >> ~/asurite-ids-output.csv
done
