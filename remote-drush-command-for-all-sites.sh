#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass Drush operations on all of your Pantheon sites (in the Live environment)!\n\n"

read -p 'Please enter your Drush command: ' command

declare -a arr="($(terminus site:list --fields=name,framework | sed -e '/wordpress/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

for i in "${arr[@]}"
do
  terminus remote:drush "$i".live -- $command
done

unset arr
