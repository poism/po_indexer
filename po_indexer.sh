#!/bin/bash
# Po's filesystem index to offline HTML search website
# Add this as a cronjob to index a directory (or network share) and generate a website search
# NOTE: This does NOT require apache, you can upload the website to your network share :)
# Make sure to chmod u+x po_indexer.sh

INDEX_PATH=../../
WEB_PATH=../

# Create source file
find $INDEX_PATH -type f -exec du -h {} \; > tmp/src_index.txt

# Convert source file to JSON for webpage
python scripts/po_indexGenerator.py

mv tmp/index.json $WEB_PATH
