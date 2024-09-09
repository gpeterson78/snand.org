# the snand foundation
*a place for snand*
---
welcome to the official repository for snand.org, where we maintain all the necessary files and configurations to run our pile of garbage. this repository is primarily focused on the stuff I use to learn and play with when building snand.org. the purpose of this repository is both educational and to provide hosting services for family-related projects. Projects here are under *very* active development and should not be used by anyone (including me) but be my guest.

### projects list
This repository includes the following projects (list will grow):

- **traefik**: uses letsencrypt and cloudflare to provide certificates to my internal services.
- **WordPress + phpMyAdmin**: runs snand.org. ~~or will anyway, once I successfully migrate this project~~
- **Immich**: not yet but likely next up.

### usage
this is the setup and update script for snand.  this setup assumes a vanilla linux install with docker to operate.  to get started, clone this repo to the directory you want snand installed:
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