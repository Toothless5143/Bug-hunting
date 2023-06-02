# Bug hunting checklist by Toothless:

### 1. Recon
- [ ] Run Script

### 2. Information Gathering
- [ ] Google Dorks
- [ ] Github
- [ ] OSINT
- [ ] Pastebin

### 3. Source Code Analysis
- [ ] Gathering js files (subjs, waybackurls)
- [ ] Finding API Keys, Infos (secretfinder, js miner)
- [ ] Linkfinder

### 4. Scanning
- [ ] Nmap Scan & Identify ports
- [ ] Crawling/Spidering the site
- [ ] Check for robots.txt and other files
- [ ] Directory Fuzzing (dirb, gobuster, ffuf)
- [ ] URL Gathering (hakrawler, gau, waybackurls, paramspider)

### 5. Manual
- [ ] Use Wappalyzer to detect technology
- [ ] Manually walking through the site
- [ ] Loading up burp with every functionality
- [ ] Testing Authentication (bypass, 2fa bypass, forgot password, remember me, brute force, etc)
- [ ] Session Management (jwt, tokens, cookies, csrf, click jacking, etc)
- [ ] Testing Authorization (path traversal, privillage escalation, IDOR, etc)
- [ ] Testing Data Validation (xss, sqli, html injection, lfi/rfi, xxe, verb tempering, etc)
- [ ] Testing Business Logic
