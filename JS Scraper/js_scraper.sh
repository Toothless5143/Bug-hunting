#!/bin/bash

cat subdomains_live.txt | httpx -silent | subjs | tee subjs.txt

cat subdomains_live.txt | waybackurls | tee waybackurls_dead.txt
cat waybackurls_dead.txt | grep "\.js" | tee waybackurls.txt

cat waybackurls.txt | httpx -silent -fc 404 | tee waybackurls_js.txt

cat subjs.txt waybackurls_js.txt | sort -u | uniq | tee js.txt
rm -rf subjs.txt waybackurls_dead.txt waybackurls_js.txt
