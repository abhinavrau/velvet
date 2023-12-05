# Velvet
 - [Vertex AI Search](https://cloud.google.com/enterprise-search) Verfication Tool

## Features
- Call [Vertex AI Search](https://cloud.google.com/enterprise-search) API from the command line
- Batch search support and output to CSV and JSONL
- Batch verification for Acceptance testing

## Dependencies
  - bash shell v4+
  - curl
  - jq
  - gcloud
  - Linux or macOS
  
## Install

Clone this repo or just copy the [vlvt](./vlvt) to your local  machine with bash support. Open termnial and change the permission to make it executable

```bash
$ chmod +x ./vlvt
```

## Setup

1. For MacOS users please ensure you have bash v4+ installed. To check run 
```bash
$ bash --version
```
To upgrade follow direction [here](https://itnext.io/upgrading-bash-on-macos-7138bd1066ba)

2. Setup [gcloud](https://cloud.google.com/sdk/docs/install-sdk) cli and authenticate to make sure you have access to the project with ES you want to query

3. Install dependent tools. This installs [jtbl](https://github.com/kellyjonbrazil/jtbl) curently

```bash
$ ./vlvt init
```

1. Make sure you export the following env variables.

```bash
$ export GCP_PROJECT_NUMBER=<vertex-ai-search-gcp-project-number> 
$ export DATASTORE_NAME=<vertex-ai-search-search_datastore_name> 
$ export PROJECT_ID=<palm-text-bison-project-id> # used for matching summaries
$ export LOCATION_ID=<palm-text-bison-region-name>
```

## Examples
Single search with csv output. Only shows the summary and first document link
```bash
    $ ./vlvt search "What is Google's revenue for year ending 2022?" 
```
Single search with table output. Only shows the summary and first document link
```bash
    $ ./vlvt s "What is Google's revenue for year ending 2022?" --format=table 
```
Single search with json output
```bash
    $ ./vlvt s "What is Google's revenue for year ending 2022?" -f=json 
```
Batch search with input file containing search queries and output a csv file with results. Only shows the summary and first document link
```bash
    $ ./vlvt bsearch test/data/batch_test.txt --format=table 
```
Batch search AND verify with input file containing search queries with expected resutls and output results to a csv file.
```bash
    $ ./vlvt verify test/data/verification_test_with_prompt.csv --format=csv
  ```