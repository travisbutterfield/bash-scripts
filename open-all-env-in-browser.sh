#!/bin/bash

IFS=$'\n'

echo 'Provide the environment you want to open in your browser:';
read ENV;

#get list of sites and clean it up
declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/policyinformatics/d' | sed -e '/vanillad7/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#arr=("cemhs" "copp")
# printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  terminus env:wake -- "$i.$ENV"
  firefox "https://$ENV-$i.ws.asu.edu"
done