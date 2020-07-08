#!/bin/bash

declare -a sitesArr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

# declare -a sitesArr=("cemhs" "cord")
# printf '%s\n' "${sitesArr[@]}"

for i in "${sitesArr[@]}"
do
  if [[ $(find /var/www/html -name "$i") ]]
    then
      echo "$i already exists locally"
    else
      url="$(terminus connection:info --fields=git_url --yes -- $i.dev | sed -n '1,1 !p' | sed -n '$ !p' | sed 's/Git URL//' | tr -s ' ' | tr -d ' ' | tr -d '\n')"
      $(cd /var/www/html/; git clone $url $i)
  fi
done