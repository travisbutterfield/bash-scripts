#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass Drush operations on all of your Pantheon sites!\n\n"

read -p 'Please enter your Drush command: ' command

declare -a arr="($(ls /var/www/html/ | grep -v "\."))"

#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  drush @"$i".local $command;
  printf "....................\n\n";
done

unset arr
