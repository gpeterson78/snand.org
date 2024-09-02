all commands run during install of snand's obsolete hardware.

---
##
server specs:
- dell optiplex 3050
- i5-6500t, 2.5ghz
- 16 GB RAM
- 256 GB 

## base debian install - headless
- hostname: snand
- domain: dundermifflin
- root account pw: *redacted*
- user account: grady peterson
- user pw: *redacted*
- all one partition *(everything will be docker)*
- installed
  - ssh server
  - standard system utilities

## post install steps
- install sudo and add myself
```bash
gradyp@halpert:~/Videos$ ssh snand
The authenticity of host 'snand (10.0.0.166)' can't be established.
ED25519 key fingerprint is SHA256:qBDzBYOv1xHCBinHkF+b7q3OyKIQ8xljVif2zTNjwrM.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'snand' (ED25519) to the list of known hosts.
gradyp@snand's password: 
Linux snand 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
gradyp@snand:~$ su -
Password: 
root@snand:~# apt-get update && apt-get upgrade -y
Hit:1 http://deb.debian.org/debian bookworm InRelease
Hit:2 http://security.debian.org/debian-security bookworm-security InRelease
Hit:3 http://deb.debian.org/debian bookworm-updates InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
root@snand:~# apt-get install sudo -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  sudo
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 1,889 kB of archives.
After this operation, 6,199 kB of additional disk space will be used.
Get:1 http://deb.debian.org/debian bookworm/main amd64 sudo amd64 1.9.13p3-1+deb12u1 [1,889 kB]
Fetched 1,889 kB in 0s (9,379 kB/s)
Selecting previously unselected package sudo.
(Reading database ... 29272 files and directories currently installed.)
Preparing to unpack .../sudo_1.9.13p3-1+deb12u1_amd64.deb ...
Unpacking sudo (1.9.13p3-1+deb12u1) ...
Setting up sudo (1.9.13p3-1+deb12u1) ...
Processing triggers for man-db (2.11.2-2) ...
Processing triggers for libc-bin (2.36-9+deb12u8) ...
root@snand:~# usermod -aG sudo gradyp
root@snand:~# exit
logout
gradyp@snand:~$ exit
logout
Connection to snand closed.
```
- disable wireless and set static IP for wired:
```bash
gradyp@snand:~$ sudo nano /etc/network/interfaces
  GNU nano 7.2                                  /etc/network/interfaces                                            
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp1s0
iface enp1s0 inet static
    address 10.0.0.19/24
    gateway 10.0.0.1
    dns-nameservers 10.0.0.11

# Disable wireless interface
# allow-hotplug wlp2s0
# iface wlp2s0 inet dhcp
#     wpa-ssid DunderMifflin
gradyp@snand:~$ sudo reboot

Broadcast message from root@snand on pts/1 (Sun 2024-09-01 14:52:26 CDT):

The system will reboot now!

gradyp@snand:~$ Connection to snand closed by remote host.
Connection to snand closed.
```
## post install steps
### Install required packages
sudo apt-get install -y ca-certificates curl gnupg lsb-release
### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
### Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


---



### Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

### Start and enable Docker
sudo systemctl enable docker
sudo systemctl start docker

### Test the installation
sudo docker run hello-world

### (Optional) Add your user to the docker group
sudo usermod -aG docker yourusername

### Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

### Start and enable Docker
sudo systemctl enable docker
sudo systemctl start docker

### Test the installation
```bash
gradyp@snand:/$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c1ec31eb5944: Pull complete
Digest: sha256:53cc4d415d839c98be39331c948609b659ed725170ad2ca8eb36951288f81b75
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

 sudo apt install curl
 curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
```

