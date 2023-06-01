#!/bin/bash

# Download the wildcards.txt file from the specified URL
wget https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/main/data/wildcards.txt

# Remove asterisks (*) at the beginning of each line and exclude lines containing asterisks
cat ~/wildcards.txt | sed 's/^*.//g' | grep -v '*' > wildcards_without_stars.txt

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
