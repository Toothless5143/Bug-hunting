| **Command** | **description** |
| --- | --- |
| **URL Gathering** | |
| `echo "domain.com" \| waybackurls \| tee waybackurls_dead.txt` | gathering all the urls from the way back machine |
| `echo "domain.com" \| gau \| tee gau.txt` | gathering urls from a tool named gau |
| `echo "domain.com" \| hakrawler \| hakrawler.txt` | gathering urls from a tool named hackrawler |
| `cat  * \| sort -u \| uniq  \| tee unique.txt` | only keeping the unique outputs |
| `cat "file.txt" \| httpx -silent -fc 404 \| tee live_website.txt` | inputing a bunch of input and only keeping the live hosts/targets using httpx | 
