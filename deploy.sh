#! /bin/bash

bin/html_table > medal-table.html

scp medal-table.html admin@londonamateurbrewers.co.uk:/srv/londonamateurbrewers.co.uk/public/htdocs/medal-table.html

