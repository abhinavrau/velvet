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
$ ./vlvt i
```

4. Make sure you export the following env variables. The GCP project number and the Enterprise search datastore name

```bash
$ export GCP_PROJECT_NUMBER=<gcp-project-number> 
$ export DATASTORE_NAME=<search_datastore_name>
```

## Simple search
Returns the raw JSON reply from the API

```bash
$ ./vlvt s '<search query>'
```

## Minimal Search
Only returns the top summary and it's relevant document reference
```bash
$ ./vlvt s '<search query>' -m
```

## Search with output in CSV format
Only returns the top summary and it's relevant document reference
```bash
$ ./vlvt s '<search query>' -c
```

## Batch CSV 

Run query from a external text file and output to csv. Text file contains one query per line

```bash
$ ./vlvt b input_file_with_queries output_csv_file
```

## This is not an Official Google product
