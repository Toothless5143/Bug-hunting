#!/bin/bash

# Prompt user for domain name
read -p "Enter the domain name: " domain

# Creating a directory to store all of the files
mkdir $domain
cd $domain

# Commands execution
subfinder -d $domain -all | tee subfinder.txt
assetfinder --subs-only $domain | tee assetfinder.txt
python ~/Tools/ctfr/ctfr.py -d $domain -o ctfr.txt

# Run amass and ffuf commands in the background
( amass enum -d $domain > amass.txt ) &
amass_pid=$!
( ffuf -w /usr/share/wordlists/SecLists-master/Discovery/DNS/subdomains-top1million-110000.txt -u http://FUZZ.$domain -o fuzzing.txt && kill $amass_pid ) &
# also we can use the wordlist 'dns-Jhaddix.txt' for deep recon but its gonna take ages to complete the whole process

# Wait for ffuf to finish
wait $!

# Processing subdomains
cat fuzzing.txt | jq -r '.results[].url' | sed 's/.*\///' | tee ffuf.txt
rm -rf fuzzing.txt
cat * | sort -u | uniq | tee subdomains.txt
rm -rf subfinder.txt assetfinder.txt ctfr.txt amass.txt ffuf.txt

# Looking if there are any possibilties of subdomain takeover
subzy run --targets subdomains.txt --hide_fails | tee subzy.txt

# Data processing and generating urls from the scrapped data
cat subdomains.txt | httpx -silent -fc 404 | awk -F/ '{print $3}' | tee subdomains_live.txt

cat subdomains_live.txt | waybackurls | tee waybackurls_dead.txt
cat waybackurls_dead.txt | httpx -silent -fc 404 | tee waybackurls.txt
rm -rf waybackurls_dead.txt

# Gathering js files for source code analysis
cat subdomains_live.txt | httpx -silent | subjs | tee subjs.txt
cat waybackurls.txt | grep "\.js" | tee waybackurls_js.txt

# Run paramspider for each domain in subdomains_live.txt
cat subdomains_live.txt | xargs -I@ sh -c 'python ~/Tools/ParamSpider/paramspider.py -d @'
