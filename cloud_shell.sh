#!/bin/bash

# Prompt user for domain name
read -p "Enter the domain name: " domain

# Commands execution
subfinder -d $domain -all | tee subfinder.txt
assetfinder --subs-only $domain | tee assetfinder.txt
python ~/Tools/ctfr/ctfr.py -d $domain -o ctfr.txt

ffuf -w /usr/share/wordlists/SecLists-master/Discovery/DNS/dns-Jhaddix.txt -u http://FUZZ.$domain -o fuzzing.txt


# Run amass command and terminate after 30 minutes
( amass enum -d $domain | tee amass.txt ) & sleep 1800 && kill $(pgrep -f "amass enum -d $domain")
wait
cat fuzzing.txt | jq -r '.results[].url' | sed 's/.*\///' | tee ffuf.txt
rm -rf fuzzing.txt
cat * | sort -u | uniq | tee $domain.txt

# Data processing
cat $domain.txt | httpx -silent -fc 404 | awk -F/ '{print $3}' | tee $domain_live.txt
cat $domain_live.txt | httpx -silent | subjs | tee $domain_subjs.txt
cat $domain_live.txt | waybackurls | tee $domain_waybackurls_dead.txt
cat $domain_waybackurls_dead.txt | httpx -silent -fc 404 | tee $domain_waybackurls.txt
rm -rf $domain_waybackurls_dead.txt
cat  | grep "\.js" | tee $domain_waybackurls_js.txt
