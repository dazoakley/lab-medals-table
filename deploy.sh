#! /bin/bash

bin/html_table > medal-table/index.html
bin/roll_of_honour > medal-table/roll-of-honour.html

rsync -e ssh --delete -varuzP medal-table/ admin@londonamateurbrewers.co.uk:/srv/londonamateurbrewers.co.uk/public/htdocs/medal-table/
