#!/bin/bash

printf "\nHello!\n\nThis will check a pantheon site to find which currently enabled modules have a D8 version\n\n"

read -p "Site Pantheon name: " siteName

printf "please wait while I fetch the data...\n"

declare -a moduleArr="($(terminus drush $siteName.live -- pm-list --type=Module --no-core --status=enabled --fields=name 2>/dev/null | sed -n '1,1 !p' | sed -e '/asu_/d' | sed -e '/ASU/d' | sed -e '/webspark/d' | cut -d"(" -f2 | cut -d")" -f1))"

# declare -a moduleArr="(search_api_views facetapi)"

# printf '%s\n' "${moduleArr[@]}"

declare -a resultArr

for i in "${moduleArr[@]}"
do
  eightTest=$(lynx --source http://updates.drupal.org/release-history/$i/8.x | xpath -e '/project/releases/release[1]/name' 2>/dev/null | sed 's/<name>//g' | sed 's/<\/name>//g' | cut -d ' ' -f2)
  length=$(expr length "$eightTest")

	if [[ $length -gt 0 ]]
	then
		resultArr+=( "$i: $eightTest" )
	else
		resultArr+=( "$i: No D8 version available. Maybe?" )
	fi
done

IFS=$'\n' 
sortedArr=($(sort <<<"${resultArr[*]}"))
unset IFS

printf '%s\n' "${sortedArr[@]}"

unset moduleArr
unset resultArr
unset sortedArr