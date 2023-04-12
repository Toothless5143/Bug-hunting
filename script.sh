# A bash script to perform automated things during a bug bounty program.
function subenum(){
	subfinder -d $1 -all | tee $1.txt # using subfinder to get subdomains.
	assetfinder --subs-only $1 | tee -a $1.txt # using assetfinder to get subdomains and appending the previous file.
	amass enum -d $1  | tee -a $1.amass  # using amass tool to get subdomains in a different file.
	python ~/Tools/ctfr/ctfr.py -d $1 | tee -a $1.txt # using ctfr to get subdomains and saving them in a different file.
	cat  * | sort -u | uniq  | tee unique.txt # sorting 3 of the files and creating a new file only containing unique subdomains.
	cat $1_uniq | dnsgen - | massdns -r /usr/share/wordlists/resolvers.txt -t A -o S -w massdns.txt # finding dns resolved ip of every single subdomains we found so far.
  }
  
function finder(){
  python ~/Tools/SecretFinder/SecretFinder.py -i unique.txt -o secretfinder.txt
  }
  
  
