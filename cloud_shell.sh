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
subfinder -d $1 -all | anew $1.txt
assetfinder --subs-only $1 | anew $1.txt
python ~/Tools/ctfr/ctfr.py -d $1 | anew $1.txt
amass enum -d $1 | anew $1.txt
cat  * | sort -u | uniq  | tee $1_unique.txt

# Data processing
cat $1.txt | httpx -silent -fc 404 | awk -F/ '{print $3}' | tee $1_live.txt

cat $1_live.txt | httpx -silent | subjs | tee $1_subjs.txt

cat $1_live.txt | waybackurls | tee $1_waybackurls.txt
cat $1_waybackurls.txt | grep "\.js" | tee $1_waybackurls_js.txt
cat $1_waybackurls_js.txt | httpx -silent -fc 404 | tee $1_waybackurls_live_js.txt

# Removing useless files
rm -rf $1_waybackurls.txt $1_waybackurls_js.txt



