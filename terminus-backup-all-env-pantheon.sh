#!/bin/bash

IFS=$'\n'

printf "\nHello!\n\nWelcome to my bash script for doing mass backup on all of your Pantheon sites!\n\n"
read -r -p 'Please designate the desired environment (dev, test, live): ' env

# declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/policyinformatics/d' | sed -e '/vanillad7/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
declare -a arr=("techsociety" "crim" "copp-community" "psa" "morrison2017" "publicpolicy" "cpop" "cabhp" "lifelonglearning" "cord" "copp" "socialwork")
#uncomment next line to check array
printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus backup:create -- '"$i"'.'"$env"'; printf "....................\n\n"; $SHELL'
done

unset arr
