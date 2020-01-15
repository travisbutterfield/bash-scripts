#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass git push operations on all of your Pantheon sites (from dev to test)!\n\n"
IFS='\n'
read -p 'Please add a note for this mass deployment: ' note

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -e '/lodestar/d' | sed -e '/copp-community/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
# declare -a arr=("pubsrvstarter")

#uncomment next line to check array
# printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus env:deploy --sync-content --note="'"$note"'" --cc --updatedb -- '"$i"'.live; printf "....................\n\n"; $SHELL'
  # printf "..... $i .....\n";
  # terminus env:deploy --sync-content --note="$note" --cc --updatedb -- "$i".live;
  # printf "....................\n\n";
done

unset arr
