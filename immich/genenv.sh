#!/bin/sh
# Setup Script for snand.org's Self-Hosted Immich photo and backup site
#
# This script assists in the initial setup for Immich in snand's suite of self-hosted applications.
#
# Author: Grady Peterson
# Website: https://snand.org
# License: MIT License
# Feel free to use and modify this script for any purpose.
# This script comes with no warranty or guarantees.
#
# Last Updated: 2024-03-09
DB_PASSWORD=$(openssl rand -base64 36)

# Prompt user for Upload location
read -p "The location where your uploaded files are stored (./library as default): " UPLOAD_LOCATION
UPLOAD_LOCATION=${UPLOAD_LOCATION:-'./library'}

# Prompt user for Docker Network (traefik-network default - sorry, this is for snand after all)
read -p "Provide the Network Name (traefik-network as default): " NETWORK_NAME
NETWORK_NAME=${NETWORK_NAME:-'traefik-network'}

# Prompt user for Immich URL
read -p "Please provide the Immich URL (default immich.snand.org): " IMMICH_URL
IMMICH_URL=${IMMICH_URL:-'immich.snand.org'}

read -p "The Immich version to use. You can pin this to a specific version like "v1.71.0" (default release): " IMMICH_VERSION
IMMICH_VERSION=${IMMICH_VERSION:-release}

read -p "The environment name (default immich): " ENV_NAME

# Write all variables at once to the .env file
{
    echo "DB_PASSWORD=$DB_PASSWORD"
    echo "UPLOAD_LOCATION=$UPLOAD_LOCATION"
    echo "IMMICH_VERSION=$IMMICH_VERSION"
    echo "NETWORK_NAME=$NETWORK_NAME"
    echo "ENV_NAME=$ENV_NAME"
    echo "IMMICH_URL=$IMMICH_URL"
###################################################################################
# The values below this line do not need to be changed
###################################################################################
    echo "DB_HOSTNAME=immich_postgres"
    echo "DB_USERNAME=postgres"
    echo "DB_DATABASE_NAME=immich"
    echo "REDIS_HOSTNAME=immich_redis"
} > .env

UPLOAD_LOCATION=./library
IMMICH_VERSION=release

DB_HOSTNAME=immich_postgres
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
REDIS_HOSTNAME=immich_redis
