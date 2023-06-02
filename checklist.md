# Bug hunting checklist by Toothless:

### 1. Recon
- [ ] Run Script

### 1.1 Massive Recon
- [ ] Checking for subdomain takeover in a massive quantity
- [ ] Gathering js files in a massive quantity (subjs, waybackurls)
- [ ] Finding API Keys, Infos (secretfinder, js miner)

### 2. Information Gathering
- [ ] Google Dorks
- [ ] Github
- [ ] OSINT
- [ ] Pastebin

### 3. Automation
- [ ] URL Gathering (hakrawler, gau, waybackurls, paramspider)
- [ ] Linkfinder
- [ ] Directory Fuzzing (dirb, gobuster, ffuf)
- [ ] Crawling/Spidering the site

### 5. Manual
- [ ] Nmap Scan & Identify ports
- [ ] Check for robots.txt and other files
- [ ] Use Wappalyzer to detect technology
- [ ] Manually walking through the site
- [ ] Loading up burp with every functionality
- [ ] Testing Authentication (bypass, 2fa bypass, forgot password, remember me, brute force, etc)
- [ ] Session Management (jwt, tokens, cookies, csrf, click jacking, etc)
- [ ] Testing Authorization (path traversal, privillage escalation, IDOR, etc)
- [ ] Testing Data Validation (xss, sqli, html injection, lfi/rfi, xxe, verb tempering, etc)
- [ ] Testing Business Logic
