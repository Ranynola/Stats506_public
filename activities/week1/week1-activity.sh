#!/bin/sh

# 79: --------------------------------------------------------------------------     
# Stats 506, Fall 2020
#!usr/bin/env bash

# Stats 506, Fall 2020
#
# Include a title and descriptive header with the same elements described
# in `psX_template.R`
#
# Author(s): James Henderson
# Updated: September 13, 2020
# 79: -------------------------------------------------------------------------

# a - download data if not present
file="recs2015_public_v4.csv"
url="https://www.eia.gov/consumption/residential/data/2015/csv/$file"

if [ ! -f "$file" ]; then
  wget $url
fi

# b - extract header row and output to a file with one name per line
new_file="recs_names.txt"

# delete the file if it is present
if [ -f "$new_file" ]; then
  rm "$new_file"
fi

< $file head -n1 | tr , \\n > "$new_file"

# c - get column numbers for DOEID and the brr weights
# as a comma separated string
cols=$(
  < $new_file grep -n -E "DOEID|BRR" | \
      cut -f1 -d: | paste -s -d, -  
)
## clean up
rm $new_file

# d - cut out the appropriate columns
<"$file" cut -f"$cols" -d, > recs_brrweights.csv

# 79: -------------------------------------------------------------------------
