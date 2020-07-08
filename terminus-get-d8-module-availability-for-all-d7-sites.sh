#!/bin/bash

function getModuleStatus {
  # read -p "Site Pantheon name: " siteName
  siteName=${j}
  # printf "$siteName\n"

  printf "Please wait while I fetch the data...\n"

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
      resultArr+=( "$i: No D8 version available" )
    fi
  done

  IFS=$'\n' 
  sortedArr=($(sort <<<"${resultArr[*]}"))
  mkdir -p ~/d8-module-status-files
  printf '%s\n' "${sortedArr[@]}" >| ~/d8-module-status-files/"$siteName".txt
  printf '%s\n' $(cat ~/d8-module-status-files/"$siteName".txt)
  printf "..........................................\n
  Your results have been saved at: ~/d8-module-status-files/$siteName.txt\n\n"

  unset moduleArr
  unset resultArr
  unset sortedArr
  unset IFS
}

function loopSites {
  printf "\nHello!\n\nThis will check all D7 pantheon sites to find which currently enabled modules have a D8 version\n\n"

  declare -a siteArr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
  # declare -a siteArr="(copp crim)"

  # printf '%s\n' "${siteArr[@]}"

  for j in "${siteArr[@]}"
  do
    getModuleStatus
  done

  unset siteArr
}

loopSites