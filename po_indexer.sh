#!/bin/bash
# Sherab Sangpo Dorje (po@poism.com)
# Po's filesystem index to offline HTML search page
# Drop this entire folder into the directory/network share you wish to index
# Run ./po_indexer.sh and it will generate the index.html (search page) into the parent directory
# NOTE: This does NOT require a webserver, the index.html can live on your HDD or network share :)
# Also, of course make sure to chmod u+x po_indexer.sh
# Add po_indexer.sh as a cronjob to automate 

DATE=`date`
PAGE_HEADER="<h1>Podshare Search Index</h1><p><b>Last updated:</b> $DATE</p>" #adjust this to the share name if you wish
# If possible avoid messing with these paths, just put this whole folder in the directory you wish to index
INDEX_PATH=../
INDEX_PAGE=../index.html

# Create source index 
START_PATH=`pwd`
OUTPUT=/tmp/src_index.txt
cd $INDEX_PATH
find . -type f -exec du -h {} \; > $START_PATH$OUTPUT
cd $START_PATH

# Convert source index to JSON format
python scripts/po_indexGenerator.py

# Assemble index.html search page
cat template/top.html > $INDEX_PAGE
cat template/js/jquery.js >> $INDEX_PAGE
cat template/top2.html >> $INDEX_PAGE
cat tmp/index.json >> $INDEX_PAGE
cat template/top3.html >> $INDEX_PAGE
echo $PAGE_HEADER >> $INDEX_PAGE
cat template/bottom.html >> $INDEX_PAGE

# Cleanup
rm tmp/*

