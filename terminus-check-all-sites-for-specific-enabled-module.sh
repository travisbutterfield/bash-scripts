#!/bin/bash

printf "\nHello!\n\nThis will check all pantheon sites to find if a specific module is currently enabled\n\n"

read -p "Module machine name: " moduleName

printf "\n Please wait while I gather the data...\n\n"

declare -a siteArr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/morrison-institute/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

#declare -a siteArr="(northamericanprocess copp lodestar crd)"
# printf '%s\n' "${siteArr[@]}" `#check array`

declare -a filteredArr="()"

for i in "${siteArr[@]}"
do
  test=$(terminus drush $i.live -- pm-list --type=Module --no-core --status=enabled | grep -c $moduleName)
  if [[ $test -gt 0 ]]
  then
    filteredArr+=( $i )
  fi
done

if [[ ${#filteredArr[@]} -gt 0 ]]
then
  printf '%s\n' "${filteredArr[@]}"
else
  printf 'There are no items in this array\n\n'
fi

unset siteArr
unset filteredArr
