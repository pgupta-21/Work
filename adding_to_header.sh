#!/bin/bash
# Find all fasta files within subfolders and process them

find . -maxdepth 2 -mindepth 2 -type f -name "*.fasta" | parallel '
    subfolder=$(basename $(dirname {}))
    tmp_file=$(mktemp)
    awk -v subfolder="$subfolder" \
    '"'"'
    /^>/ {
        if ($0 !~ "^>" subfolder "_") {
            print ">" subfolder "_" substr($0, 2)
        } else {
            print $0
        }
        next
    }
    { print $0 }
    '"'"' {} > "$tmp_file"
    mv "$tmp_file" {}
'

 
