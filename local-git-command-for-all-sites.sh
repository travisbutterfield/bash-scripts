#!/bin/bash -e

printf "\nHello!\n\nWelcome to my bash script for doing mass local git operations on all of\nyour downloaded Pantheon sites!\n\nPlease enter your full git command.\n\n"
IFS=$'\n'
read -p 'Enter command: ' command

# declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/policyinformatics/d' | sed -e '/spa/d' | sed -e '/vanillad7/d' | sed -e '/techsociety/d' | sed -e '/crim/d' | sed -e '/copp-community/d' | sed -e '/psa/d' | sed -e '/morrison2017/d' | sed -e '/publicpolicy/d' | sed -e '/cpop/d' | sed -e '/lodestar/d' | sed -e '/cabhp/d' | sed -e '/lifelonglearning/d' | sed -e '/copp/d' | sed -e '/socialwork/d' | sed -e '/cord/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
declare -a arr=("cord" "copp" "socialwork" "techsociety" "crim" "copp-community" "psa" "morrison2017" "publicpolicy" "cpop" "cabhp" "lifelonglearning")

printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'cd /var/www/html/'"$i"'; printf "..... '"$i"' .....\n"; eval '"'$command'"'; printf "....................\n\n";$SHELL'
done

unset arr
