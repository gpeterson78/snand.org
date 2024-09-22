#!/bin/sh
# script to move photos from folders named like 01-01-2001 (MM-DD-YYYY) to folders named MM in the current directory
# not useful in the slightest, just for cleaning up snand's old crap.  
# will likely be deleted but maybe I'll keep it for future reference.

# Loop through directories in the current path matching the MM-DD-YYYY pattern
for dir in [0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        # Extract the month (first two characters)
        month="${dir%%-*}"
        
        # Create the target month folder if it doesn't exist
        mkdir -p "$month"
        
        # Move all files from the current directory to the month folder
        mv "$dir"/* "$month/"
        
        # Remove the now-empty directory
        rmdir "$dir"
    fi
done
