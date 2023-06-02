#!/bin/bash

# Function to handle Ctrl+C signal
function handle_ctrl_c() {
  echo "Process interrupted. Skipping to the next step..."
  exit 0
}

# Set Ctrl+C signal handler
trap handle_ctrl_c INT

# Prompt user for domain name
read -p "Enter the domain name: " domain

# Creating a directory to store all of the files
mkdir "$domain"
cd "$domain" || exit 1

# Commands execution
subfinder -d "$domain" -all | tee subfinder.txt
assetfinder --subs-only "$domain" | tee assetfinder.txt
python ~/Tools/ctfr/ctfr.py -d "$domain" -o ctfr.txt

# Run amass and ffuf commands in the background
( amass enum -d "$domain" > amass.txt ) &
amass_pid=$!
( ffuf -w /usr/share/wordlists/SecLists-master/Discovery/DNS/subdomains-top1million-110000.txt -u "http://FUZZ.$domain" -o fuzzing.txt && kill "$amass_pid" ) &

# Wait for ffuf to finish or handle Ctrl+C
wait $! || handle_ctrl_c

# Processing subdomains
cat fuzzing.txt | jq -r '.results[].url' | sed 's/.*\///' | tee ffuf.txt
rm -rf fuzzing.txt
cat * | sort -u | uniq | tee subdomains.txt
rm -rf subfinder.txt assetfinder.txt ctfr.txt amass.txt ffuf.txt

# Looking if there are any possibilities of subdomain takeover
subzy run --targets subdomains.txt --hide_fails | tee subzy.txt

# Data processing and generating URLs from the scrapped data
cat subdomains.txt | httpx -silent -fc 404 | awk -F/ '{print $3}' | tee subdomains_live.txt

# Resolving the subdomains
# cat subdomains_live.txt | massdns -r /usr/share/wordlists/resolvers.txt -t A -o S -w resolved.txt

# Getting screenshots
cat subdomains_live.txt | ~/Tools/aquatone/./aquatone -out aquatone.txt
