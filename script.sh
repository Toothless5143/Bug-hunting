# A bash script to perform automated things during a bug hunting.

# A function to gather all the subdomains we need to do further analysis.
function subenum(){
	subfinder -d $1 -all | anew $1.txt # using subfinder to get subdomains.
	assetfinder --subs-only $1 | anew $1.txt # using assetfinder to get subdomains.
	amass enum -d $1  | tee amass.txt  # using amass tool to get subdomains.
	python ~/Tools/ctfr/ctfr.py -d $1 | tee ctfr.txt # using ctfr tool to get subdomains.
	cat  * | sort -u | uniq  | tee unique.txt # sorting 4 of the files and creating a new file only containing unique subdomains.
	cat unique.txt | dnsgen - | massdns -r /usr/share/wordlists/resolvers.txt -t A -o S -w massdns.txt # finding dns resolved ip of every single subdomains we found so far.
  }
  
function jsfinder(){
	cat unique.txt | httpx -silent -fc 404 | awk -F/ '{print $3}' | tee alivesubdomains.txt
	cat alivesubdomains.txt | waybackurls | tee waybackurls.txt
	
	cat waybackurls.txt | grep "\.js" | tee js.txt
	cat url.txt | httpx --status-code -fc 404 | tee waybackurl_js.txt
	
	cat unique.txt | httpx -silent | subjs | tee subjs.txt

	#anew tool
	cat js.txt | xargs -I@ sh -c 'python ~/Tools/SecretFinder/SecretFinder.py -i @'

	python ~/Tools/ParamSpider/paramspider.py -d gap.com  
	
  }
  
  
