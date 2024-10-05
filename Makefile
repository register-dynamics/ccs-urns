HQ ?= hq

_site/: _data/urns.csv
	bundle exec jekyll build --safe

_data/:
	mkdir -p $@

_data/urns.ods: _data/
	curl --output - 'https://www.gov.uk/guidance/current-crown-commercial-service-suppliers-what-you-need-to-know#customer-unique-reference-number-urn-list' | \
		${HQ} -a href 'a[href*="CCS_Customer_URN_List"][href$$=".ods"]' | \
		xargs curl --output '$@'

_data/urns.csv: _data/urns.ods
	bundle exec ruby -e 'require "roo"; puts Roo::Spreadsheet.open("$^").sheet(1).to_csv' > $@

.PHONY: clean
clean:
	${RM} -r _site/ _data/
