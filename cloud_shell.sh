#!/bin/bash

# Installing the tools we need
sudo apt install golang
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/assetfinder@latest
go install -v github.com/owasp-amass/amass/v3/...@master
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/tomnomnom/waybackurls@latest

cd ~/Tools/ctfr
pip3 install -r requirements.txt
cd ~/

pip3 install dnsgen

# Commands execution
subfinder -d $domain -all | anew $domain.txt
assetfinder --subs-only $1 | anew $domain.txt
python ~/Tools/ctfr/ctfr.py -d $domain | anew $domain.txt
amass enum -d $domain | anew $domain.txt
cat  * | sort -u | uniq  | tee $domain_unique.txt

# Data processing
cat $domain.txt | httpx -silent -fc 404 | awk -F/ '{print $3}' | tee $domain_live.txt

cat $domain_live.txt | httpx -silent | subjs | tee $domain_subjs.txt

cat $domain_live.txt | waybackurls | tee $domain_waybackurls.txt
cat $domain_waybackurls.txt | grep "\.js" | tee $domain_waybackurls_js.txt
cat $domain_waybackurls_js.txt | httpx -silent -fc 404 | tee $domain_waybackurls_live_js.txt

# Removing useless files
rm -rf $domain_waybackurls.txt $domain_waybackurls_js.txt



