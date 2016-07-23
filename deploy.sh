#! /bin/bash

bin/html_table > medal-table/index.html

scp -r medal-table admin@londonamateurbrewers.co.uk:/srv/londonamateurbrewers.co.uk/public/htdocs/medal-table

