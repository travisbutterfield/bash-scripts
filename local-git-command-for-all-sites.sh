#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass local git operations on all of\nyour Pantheon sites!\n\nPlease enter your full git command below.\n\n***NOTE: You must escape any special characters and flags (like \"-am\") with a\nbackslash or the command will NOT work.***\n\n"

read -p 'Enter command: ' command

declare -a arr="($(ls /var/www/html/ | grep -v "\."))"

#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  cd /var/www/html/$i; printf "..... $i .....\n"; $command; printf "....................\n\n"; #read -p 'press any key to continue';
done

unset arr
