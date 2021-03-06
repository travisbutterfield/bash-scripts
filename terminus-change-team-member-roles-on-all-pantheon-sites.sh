#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass Terminus operations on all of your Pantheon sites!\n\n This tool will loop through all ASU Drupal sites you have access to and add the desired person as a member of the team. \n\n"

command="site:team:role"
read -p "Please enter the member's Pantheon email address: " email
read -p "Please enter the member's Pantheon new role (usually team_member or developer): " pantheonrole

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

#uncomment next line to check array
printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'terminus $command '"$i"' '"$email"' "$pantheonrole"'
done

unset arr
