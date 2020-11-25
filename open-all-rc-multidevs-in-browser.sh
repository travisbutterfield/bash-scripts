#!/bin/bash

IFS=$'\n'
#get list of sites and clean it up
declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/policyinformatics/d' | sed -e '/spa/d' | sed -e '/vanillad7/d' | sed -e '/techsociety/d' | sed -e '/crim/d' | sed -e '/copp-community/d' | sed -e '/psa/d' | sed -e '/morrison2017/d' | sed -e '/publicpolicy/d' | sed -e '/cpop/d' | sed -e '/lodestar/d' | sed -e '/cabhp/d' | sed -e '/lifelonglearning/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#arr=("cemhs" "copp")
# printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  terminus env:wake -- "$i".rc
  firefox "https://rc-$i.ws.asu.edu"
done