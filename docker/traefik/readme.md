# traefik Docker Compose Project (Work in Progress)

this is the Docker Compose project for snand's traefik instance which acts as the 'ingress' for the rest of snand's docker projects.  it's main purpose is to allow for letsencrypt certificates internally while cloudflare takes care of the outside.  somehow feels more secure having one entry point and relying entirely on internal docker networking.

## Introduction

This repository contains the Docker Compose files and configuration needed to set up a self-hosted instance of traefik. this project is in an experimental stage and may undergo significant changes.  Consider it fully broken at the moment.

## Prerequisites

Before you begin, ensure you have the following installed:
- Docker
- Docker Compose