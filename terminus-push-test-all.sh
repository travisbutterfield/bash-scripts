#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass git push operations on all of your Pantheon sites (from dev to test)!\n\n"
IFS=$'\n'
read -p 'Please add a note for this mass deployment: ' note

# declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/policyinformatics/d' | sed -e '/vanillad7/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
declare -a arr="(spa crim crd copp socialwork)"

#uncomment next line to check array
printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus env:deploy --sync-content --note="'"$note"'" --updatedb -- '"$i"'.test; terminus env:cc '"$i"'.test; printf "....................\n\n"; $SHELL'
done

unset arr
