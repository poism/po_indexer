#!/bin/bash
# Sherab Sangpo Dorje (po@poism.com)
# Po's filesystem index to offline HTML search page
# Drop this entire folder into the directory/network share you wish to index
# Run ./po_indexer.sh and it will generate the index.html (search page) into the parent directory
# NOTE: This does NOT require a webserver, the index.html can live on your HDD or network share :)
# Also, of course make sure to chmod u+x po_indexer.sh
# Add po_indexer.sh as a cronjob to automate 

# DIR_TO_INDEX, OUTPUT_PATH, and INDEX_PAGE can be changed
# But, DIR_TO_INDEX and OUTPUT_PATH must be the same for html file links to work

DIR_TO_INDEX=../
OUTPUT_PATH=../
INDEX_PAGE=index.html

INDEX_PAGE=$OUTPUT_PATH$INDEX_PAGE

APP_PATH="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
APP_PATH=`dirname "$APP_PATH"`

if [ ! -d "$APP_PATH/tmp" ]; then
	mkdir "$APP_PATH/tmp"
fi

# Create source index 
cd $APP_PATH
cd $DIR_TO_INDEX
echo "Indexing `pwd`"
DIR_NAME=${PWD##*/}
find . -type f -exec du -h {} \; > "$APP_PATH/tmp/src_index.txt" 
cd $APP_PATH

# Convert source index to JSON format
echo "Running `pwd`/utilipo.py"
python utilipo.py

# Header text for the search page
DATE=`date`
PAGE_HEADER="<h1>$DIR_NAME Search Index</h1><p><b>Last updated:</b> $DATE</p>" #adjust this to the share name if you wish

# Assemble index.html search page
echo "Assembling $INDEX_PAGE "
cat template/top.html > $INDEX_PAGE
cat template/js/jquery.js >> $INDEX_PAGE
cat template/top2.html >> $INDEX_PAGE
cat tmp/index.json >> $INDEX_PAGE
cat template/top3.html >> $INDEX_PAGE
echo $PAGE_HEADER >> $INDEX_PAGE
cat template/bottom.html >> $INDEX_PAGE

# Cleanup
echo Cleaning up...
rm tmp/*

