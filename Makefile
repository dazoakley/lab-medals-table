.PHONY: build serve deploy

default: serve

build:
	bundle exec rake db:load
	bundle exec rake build:table > medal-table/index.html
	bundle exec rake build:roll > medal-table/roll-of-honour.html
	bundle exec rake build:csv > medal-table/roll-of-honour.csv
	bundle exec rake build:pot > medal-table/points-over-time.csv

serve: build
	cd medal-table && ruby -run -ehttpd . -p8000

deploy: build
	rsync -e ssh --delete -varuzP medal-table/ sympl@londonamateurbrewers.co.uk:/srv/londonamateurbrewers.co.uk/public/htdocs/medal-table/
