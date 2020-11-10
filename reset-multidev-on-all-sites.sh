#!/bin/bash
IFS=$'\n'

printf "\nHello!\n\nWelcome to my bash script for resetting a multidev environment on all Pantheon sites\n\n"

read -r -p "Please designate the multidev you want to reset: " multidev

printf '\nOpening Pantheon sites in different tabs and resetting the \"%s\" multidev.\n' "$multidev"
printf 'If \"%s\" does not exist, it will be created.\n\n' "$multidev"

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#declare -a arr=("crim")
# printf '%s\n' "${arr[@]}"
for site in "${arr[@]}"
	do
		export site
		export multidev
		function resetmultidev() {
      checkfirst=$(terminus multidev:list --fields=id --format=list -- "$site" | grep "$multidev")
      #printf "$checkfirst\n\n"
      #check if multidev exists
      if [[ "$checkfirst" != "$multidev" ]]
      then
        printf 'The \"%s\" multidev does not exist on %s. I will create it now.\n\n' "$multidev" "$site"
        terminus multidev:create "$site".live "$multidev"
      #if multidev does exist, reset it
      else
        test=$(ls -1a /var/www/html | grep -w "^$site$")
        #check if multidev has been cloned locally
        if [[ "$test" != "$site" ]]
        then
          giturl="$(terminus connection:info --format="string" --fields=git_url -- "$site".dev)"
          printf "\n\n...Please wait while I clone the site to your local environment...\n\n"
          git clone "$giturl" "/var/www/html/$site"
        fi
        #wipe multidev
        terminus env:wipe --yes "$site"."$multidev"
        cd /var/www/html/"$site" || exit
        #make local multidev branch match master branch
        git fetch --all
        git checkout "$multidev"
        git pull
        commit_hash="$(git merge-base "$multidev" master)"
        git reset "$commit_hash" --hard
        git pull -X theirs origin master
        #force push updated multidev to Pantheon
        git push origin "$multidev" --force
        terminus env:clone-content --updatedb --yes -- "$site".live "$multidev"
        terminus env:clear-cache -- "$site"."$multidev"
        git checkout master
      fi
    }
		export -f resetmultidev
		gnome-terminal --tab --title="$site" -- bash -c "resetmultidev; $SHELL"
	done
