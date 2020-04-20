.PHONY: build serve deploy

default: serve

build:
	bin/html_table > medal-table/index.html
	bin/roll_of_honour > medal-table/roll-of-honour.html
	bin/csv_export > medal-table/roll-of-honour.csv
	bin/points_over_time > medal-table/points-over-time.csv

serve: build
	cd medal-table && ruby -run -ehttpd . -p8000

deploy: build
	rsync -e ssh --delete -varuzP medal-table/ sympl@londonamateurbrewers.co.uk:/srv/londonamateurbrewers.co.uk/public/htdocs/medal-table/
