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
