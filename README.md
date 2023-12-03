# ges-tool
 - Bash CLI to interact with GCP's GenAI powered [Enterprise Search](https://cloud.google.com/enterprise-search)

## Features
- Call Enterprise Search REST API from the command line
- Currently only structured and Unstructured search is supported
- Batch search support and output to CSV
- Usefull for Acceptance testing

## Install
Clone this repo or just copy the [ges-tool](./ges-tool) to your local  machine with bash support. Open termnial and change the permission to make it executable

```bash
$ chmod +x ./ges-tool
```

## Setup

1. For MacOS users please ensure you have bash v4+ installed. To check run 
```bash
$ bash --version
```
To upgrade follow direction [here](https://itnext.io/upgrading-bash-on-macos-7138bd1066ba)

2. Setup [gcloud](https://cloud.google.com/sdk/docs/install-sdk) cli and authenticate to make sure you have access to the project with ES you want to query

3. Install dependent tools. This install [jtbl](https://github.com/kellyjonbrazil/jtbl) curently

```bash
$ ./ges-tool i
```

4. Make sure you export the following env variables. The GCP project number and the Enterprise search datastore name

```bash
$ export GCP_PROJECT_NUMBER=<gcp-project-number> 
$ export DATASTORE_NAME=<search_datastore_name>
```

## Simple search
Returns the raw JSON reply from the API

```bash
$ ./ges-tool s '<search query>'
```

## Minimal Search
Only returns the top summary and it's relevant document reference
```bash
$ ./ges-tool s '<search query>' -m
```

## Search with output in CSV format
Only returns the top summary and it's relevant document reference
```bash
$ ./ges-tool s '<search query>' -c
```

## Batch CSV 

Run query from a external text file and output to csv. Text file contains one query per line

```bash
$ ./ges-tool b input_file_with_queries output_csv_file
```

## This is not an Official Google product
