# snand.org

## the snand foundation - *a place for snand*

**license:** MIT  
**address:** [https://www.snand.org](https://www.snand.org)  
**version:** 1.0a  
**release date:** 10-22-2024  

---

## welcome to the official repository for snand.org

here is where we maintain all the necessary files and configurations to run our pile of garbage. this repository is primarily focused on the stuff I use to learn and play with when building snand.org. the purpose of this repository is both educational and to provide hosting services for family-related projects. projects here are under *very* active development and should not be used by anyone (including me), but be my guest.

### projects list

This repository includes the following projects (list will grow):

- **traefik**: uses letsencrypt and cloudflare to provide certificates to my internal services.
- **WordPress + phpMyAdmin**: current config of snand.org's  wordpress site
- **Immich**: Immich is a google photos type site that I use to backup and share our family photos.

### usage

clone this repo to a folder (I use /snand and I do try to parametarize all the paths where possible, it's likely I have this path hardcoded accidentally). then mark the snandup.sh scrip as executable and launch it (this setup assumes a vanilla linux install with git and docker).  to get started:

```bash

git clone https://github.com/gpeterson78/snand.org.git .
```

mark the setup script executable:

```bash

[sudo] chmod +x ./snandup.sh
[sudo] ./snandup.sh
```

upon execution, this script will look for and create any missing .env files, then looks for and launches any docker compose project within the directory.

### support

If you encounter any issues or have questions regarding the setup and configuration of any project contained in this repository, go ask dad.  but seriously, this comes with none and will most likely break something.

### license

This repository and its contents are provided for private use and educational purposes only. Please respect the licenses of the individual projects included within.

In addition to the above, all code directly authored by me in this repository is licensed under the MIT License, unless explicitly stated otherwise. This is applicable where I am the original author of the content; it allows you to freely use, modify, and distribute the code, subject to the following conditions:

#### MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## release Notes

### version 1.0a

- **cleaned up this file.**  If I'm versioning and keeping comments, I'd better get the format going now.
- *Future revision necessary* - need to figure out versioning system, likely in snandup script (this is ground up after all).