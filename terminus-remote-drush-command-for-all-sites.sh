#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass Drush operations on all of your Pantheon sites!\n\n"
IFS=$'\n'
read -p 'Please designate the desired environment (dev, test, live): ' env
read -p 'Please enter your Drush command (minus the initial "drush"): ' command

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
# declare -a arr="(copp crd spa crim socialwork)"


#uncomment next line to check array
printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus drush '"$i"'.'"$env"' -- '"$command"'; printf "....................\n\n"; $SHELL'
  # printf "..... $i .....\n";
  # terminus remote:drush "$i".live -- $command;
  # printf "....................\n\n";
done

unset arr
