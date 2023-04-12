# A bash script to perform automated things during a bug hunting.

# A function to gather all the subdomains we need to do further analysis.
function subenum(){
	subfinder -d $1 -all | tee $1.txt # using subfinder to get subdomains.
	assetfinder --subs-only $1 | tee -a $1.txt # using assetfinder to get subdomains and appending the previous file.
	amass enum -d $1  | tee -a $1.txt  # using amass tool to get subdomains and appending the previous file.
	python ~/Tools/ctfr/ctfr.py -d $1 | tee -a $1.txt # using ctfr tool to get subdomains and appending the previous file.
	cat  * | sort -u | uniq  | tee unique.txt # sorting 3 of the files and creating a new file only containing unique subdomains.
	cat $1_uniq | dnsgen - | massdns -r /usr/share/wordlists/resolvers.txt -t A -o S -w massdns.txt # finding dns resolved ip of every single subdomains we found so far.
	rm -rf $1.txt $1.amass $1.ctrf # removing the files we dont need for now, cause all of our scrapped subdomains are inside unique.txt and massdns.txt(resolved).
  }
  
function keysfinder(){
	cat unique.txt | waybackurls | tee URLs.txt
	cat URLs.txt | grep "\.js" | tee js.txt
	#httpx -l uniq.txt --status-code -fc 404 -o testing
  	python ~/Tools/SecretFinder/SecretFinder.py -i js.txt -o secretfinder.txt
  }
  
  
