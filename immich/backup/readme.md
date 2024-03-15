# Immich Docker Compose Project (Work in Progress)

Welcome to the Docker Compose backup and restore scripts for Immich.

## Introduction

This repository contains the backup and restore scripts for snand's Immich platform.  It is intended to be used to backup and restore immich.snand.org but if anyone finds anything useful, feel free to use it.  There are two files:

immich_backup.sh - "installed" by default with the project setup.sh.  Intended to be run as a cron job, heck maybe I'll add that option to the script next..

immich_restore.sh - this lives with it's natural sibling but is indended to be downloaded and run when needed from the project root directory.  Yes, I did this on purpose for maximum confusion.  Actually, it's one more thing that I need to be deliberate about when restoring, just so I have to think twice when playing with the dev site.

I realize I should have a container based backup solution here but I have no current plans to move to the cloud and so I don't mind backing up from the host.  it's very much inline with the simplicity that I'm after, I'll move on when I start running into limitations.