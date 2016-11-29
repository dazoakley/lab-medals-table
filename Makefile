.PHONY: build serve deploy

default: serve

build:
	bin/html_table > medal-table/index.html
	bin/roll_of_honour > medal-table/roll-of-honour.html

serve: build
	cd medal-table && ruby -run -ehttpd . -p8000

deploy: build
	rsync -e ssh --delete -varuzP medal-table/ admin@londonamateurbrewers.co.uk:/srv/londonamateurbrewers.co.uk/public/htdocs/medal-table/
