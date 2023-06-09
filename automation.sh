#!/bin/bash

# Prompt for the domain name
read -p "Enter the domain name: " domain

# Creating a directory
mkdir $domain
cd $domain

# Run waybackurls and store the output in waybackurls.txt
echo "$domain" | waybackurls | tee waybackurls.txt

# Run gau and append the output to gau.txt
echo "$domain" | gau | tee gau.txt

# Run hakrawler and append the output to hakrawler.txt
echo "$domain" | hakrawler | tee hakrawler.txt

# Combine all files into unique.txt, removing duplicate entries
cat waybackurls.txt gau.txt hakrawler.txt | sort -u | tee unique.txt

# Run httpx to filter out live URLs and store the output in live_website.txt
cat unique.txt | httpx -silent -fc 404 > live_urls.txt

# Remove unnecessary files
rm waybackurls.txt gau.txt hakrawler.txt unique.txt

echo "Process completed successfully."
