| **Command** | **description** |
| --- | --- |
| **URL Gathering** | |
| `echo "domain.com" | waybackurls | tee waybackurls_dead.txt` | gathering all the urls from the way back machine |
| `cat "file.txt" | httpx -silent -fc 404 | tee live_website.txt` | inputing a bunch of input and only keeping the live hosts/targets using httpx | 
