#!/bin/bash

# Function to execute Recon
recon() {
  # Prompt user for domain name
  read -p "Enter the domain name: " domain

  # Creating a directory to store all of the files
  mkdir "$domain"
  cd "$domain"

  # Commands execution from diff tools
  subfinder -d "$domain" -all | tee subfinder.txt
  assetfinder --subs-only "$domain" | tee assetfinder.txt
  python ~/Tools/ctfr/ctfr.py -d "$domain" -o ctfr.txt

  # Run amass and ffuf commands in the background
  ( amass enum -d "$domain" > amass.txt ) &
  amass_pid=$!
  ( ffuf -w /usr/share/wordlists/SecLists-master/Discovery/DNS/subdomains-top1million-110000.txt -u "http://FUZZ.$domain" -mc 200 -o fuzzing.txt && kill "$amass_pid" ) &

  # Wait for ffuf to finish or handle Ctrl+C
  wait $!
 
  # Processing subdomains
  cat fuzzing.txt | jq -r '.results[].url' | sed 's/.*\///' | tee ffuf.txt
  rm -rf fuzzing.txt
  cat * | sort -u | uniq | tee subdomains.txt
  rm -rf subfinder.txt assetfinder.txt ctfr.txt amass.txt ffuf.txt
  
  # Getting screenshots
  cat subdomains_live.txt | ~/Tools/aquatone/./aquatone -out aquatone.txt
}

# Function for Scraping subdomains from all bug bounty programs
scraping_subdomains() {
  # Download the wildcards.txt file from the specified URL
  wget https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/main/data/wildcards.txt

  # Remove asterisks (*) at the beginning of each line and exclude lines containing asterisks
  cat wildcards.txt | sed 's/^*.//g' | grep -v '*' > wildcards_without_stars.txt

  # Remove the original wildcards.txt file
  rm -rf wildcards.txt

  # Enumerate subdomains for each domain in wildcards_without_stars.txt
  while IFS= read -r domain; do
  echo "Enumerating subdomains for domain: $domain"
  file="${domain}_subdomains.txt"
  subfinder -d "$domain" > "$file"
  echo "Subdomains saved in $file"
  done < wildcards_without_stars.txt

  # Remove the temporary wildcards_without_stars.txt file
  rm -rf wildcards_without_stars.txt

  # Combine all subdomain files, remove duplicates, and save the result to subdomains.txt
  cat * | sort -u | uniq | tee subdomains.txt
}

# Function for js scraping
js_scraping() {
  # Collecting js files using the tool subjs
  cat subdomains_live.txt | httpx -silent | subjs | tee subjs.txt

  # Collecting js files from way ban machine and processing it
  cat subdomains_live.txt | waybackurls | tee waybackurls_dead.txt
  cat waybackurls_dead.txt | grep "\.js" | tee waybackurls.txt
  cat waybackurls.txt | httpx -silent -fc 404 | tee waybackurls_js.txt

  # Processing the Collected data
  cat subjs.txt waybackurls_js.txt | sort -u | uniq | tee js.txt
  rm -rf subjs.txt waybackurls_dead.txt waybackurls_js.txt
}

# Function for Subdomain Takeover
subdomain_takeover() {
  subzy run --targets subdomains.txt --hide_fails | tee subzy.txt
}

# Function for Resolving IPS from subdomains
resolving_ips() {
  cat subdomains_live.txt | massdns -r /usr/share/wordlists/resolvers.txt -t A -o S -w resolved.txt
}

# Function for scraping URLS
url_scraping() {
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
}