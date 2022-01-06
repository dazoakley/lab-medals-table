# LAB Medals Table Generator

This repo contains all the data and code to generate the LAB (London Amateur Brewers) medals table and associated data files.

Here is the generated output:

- Medals Table: <https://londonamateurbrewers.co.uk/medal-table/>
- Roll of Honour: <https://londonamateurbrewers.co.uk/roll-of-honour-medals/>
- Medals List (CSV): <https://londonamateurbrewers.co.uk/medal-table/roll-of-honour.csv>
- Points Over Time (CSV): <https://londonamateurbrewers.co.uk/medal-table/points-over-time.csv>

## Running the Generator(s)

You'll need to have the version of ruby defined in [.tool-versions], then simply run any of the scripts in [bin].

If you'd like to see the medals table, you can run `make serve` and a local webserver will serve the table on <http://localhost:8000>.

## Adding New Competition Results

To add results for a new competition you simply need to

- Add a new YAML file into [data] with the competition results.
- Confirm it looks ok using `make serve` and checking <http://localhost:8000>.
- Deploy to the server using `make deploy`.

You can generate the content for the YAML file either by hand (see previous files as an example), or use the "result-builder" on the LAB website - this will generate the YAML for you, then you just need to cut and paste that into a file.

<https://londonamateurbrewers.co.uk/medal-table/result-builder/>

## Adding New BJCP Style Guidelines

_TBC_
