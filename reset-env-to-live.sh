#!/bin/bash

#Authenticate Terminus
terminus auth:login

#Provide the target site name (e.g. your-awesome-site)
echo 'Provide the site name (e.g. your-awesome-site), then press [ENTER] to reset the environment to Live:';
read SITE;
echo 'Provide the environment you want to reset:';
read ENV;

#Set the Dev environment's connection mode to Git
echo "Making sure the environment's connection mode is set to Git...";
terminus connection:set "$SITE"."$ENV" git

#Identify the most recent commit deployed to Live and overwrite history on Dev's codebase to reflect Live
echo "Rewriting history on the \"$ENV\" environment's codebase...";
git reset --hard $(terminus env:code-log "$SITE".live --format=string | grep -m1 'live' | cut -f 4)

#Force push to Pantheon to rewrite history on Dev and reset codebase to Live
git push origin master -f

#Clone database and files from Live into Dev
echo "Importing database and files from Live into Dev...";
terminus env:clone-content "$SITE".live "$ENV" -y

