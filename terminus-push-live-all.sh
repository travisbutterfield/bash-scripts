#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass git push operations on all of your Pantheon sites (from test to live)!\n\n"
IFS='\n'
read -p 'Please add a note for this mass deployment: ' note

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/morrison-institute/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
# create a custom array by uncommenting and editing the next line:
# declare -a arr="(copp crim crd spa socialwork)"

#uncomment next line to check array
# printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus env:deploy --sync-content --note="'"$note"'" --updatedb -- '"$i"'.live; terminus env:cc '"$i"'.live; printf "....................\n\n"; $SHELL'
done

unset arr
