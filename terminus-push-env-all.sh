#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass git push operations on all of your Pantheon sites (i.e. from dev to test)!\n\n"
IFS=$'\n'
read -p 'Please designate the desired environment (test, live): ' env
read -p 'Please add a note for this mass deployment: ' note

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/policyinformatics/d' | sed -e '/spa/d' | sed -e '/vanillad7/d' | sed -e '/techsociety/d' | sed -e '/crim/d' | sed -e '/copp-community/d' | sed -e '/psa/d' | sed -e '/morrison2017/d' | sed -e '/publicpolicy/d' | sed -e '/cpop/d' | sed -e '/lodestar/d' | sed -e '/cabhp/d' | sed -e '/lifelonglearning/d' | sed -e '/copp/d' | sed -e '/socialwork/d' | sed -e '/cord/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
# declare -a arr="(spa crim cvpcsd7 morrison2017 crd cemhs)"

#uncomment next line to check array
printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  if [[ "$env" == "live"  ]] 
  	then
    gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus env:deploy --sync-content --note="'"$note"'" --updatedb -- '"$i"'.'"$env"'; terminus env:cc '"$i"'.test; printf "....................\n\n"; $SHELL'
  elif [[ "$env" == "test"  ]]
  	then
    gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus env:deploy --sync-content --note="'"$note"'" --updatedb --sync-content -- '"$i"'.'"$env"'; terminus env:cc '"$i"'.test; printf "....................\n\n"; $SHELL'
  else 
  	"Something went wrong. Please try again. Or not. Whatever."
  fi
done

unset arr
