#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass Drush operations on all of your Pantheon sites (in the Live environment)!\n\n"

read -p 'Please enter your Drush command (minus the initial "drush"): ' command

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#declare -a arr=("socialwork" "spa")


#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  terminus remote:drush "$i".live -- $command;
  printf "....................\n\n";
done

unset arr
