#!/bin/bash
IFS=$'\n'
# printf "\nHello!\n\nWelcome to my bash script for resetting a multidev environment on Pantheon\n\n"

#read -p "Please designate the desired website by short name: " site
read -p "Please designate the multidev you want to reset: " multidev

# printf "I will now loop through all the sites and reset this multidev on all of them."

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
# declare -a arr=("crim" "crd")
#uncomment next line to check array
# printf '%s\n' "${arr[@]}"
for site in "${arr[@]}"
	do
		export site
		export multidev
		function local_test() {
			test=$(ls -1a /var/www/html | grep -w "^$site$")
			if [[ $test != $site ]]
			then
				giturl="$(terminus connection:info --format="string" --fields=git_url -- $site.dev)"
				printf "\n\n...Please wait while I clone the site to your local environment...\n\n"
				git clone "$giturl" "/var/www/html/$site"
			fi
			terminus env:wipe --yes $site.$multidev
			cd /var/www/html/$site
			git fetch --all
			git checkout $multidev
			git pull
			commit_hash="$(git merge-base $multidev master)"
			git reset $commit_hash --hard
			git pull -X theirs origin master
			git push origin $multidev --force # Remove this line if you opt for the force push warning
			terminus env:clone-content --updatedb --yes -- $site.live $multidev
			terminus env:clear-cache -- $site.$multidev
			git checkout master
		}
		export -f local_test
		gnome-terminal --tab --title="$site" -- bash -c 'local_test; $SHELL'
	done
