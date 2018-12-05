#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass Terminus operations on all of your Pantheon sites!\n\n This tool will loop through all ASU Drupal sites you have access to and add the desired person as a member of the team. \n\n"

command="site:team:add"
read -p "Please enter the member's Pantheon email address: " email
read -p "Please enter the member's Pantheon role (usually team_member): " pantheonrole

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

for i in "${arr[@]}"
do
  terminus $command $i $email $pantheonrole
done

unset arr
