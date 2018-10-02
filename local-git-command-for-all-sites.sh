#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass local git operations on all of your Pantheon sites!\n\n"

read -p 'Please enter your full git command here: ' command

declare -a arr="($(ls /var/www/html/ | grep -v "\."))"

#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  cd /var/www/html/$i; printf "..... $i .....\n"; $command; printf "....................\n\n"; #read -p 'press any key to continue';
done

unset arr
