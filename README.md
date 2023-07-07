# ges-tool - Command Line tool to interact with GCP GenAI powered Enterprise Search

## Setup
```bash
$ export GCP_PROJECT_NUMBER=<gcp-project-number> 
$ export DATASTORE_NAME=<search_datastore_name>
```

## Simple search
Returns the raw JSON reply from the API

```bash
$ ./ges-tool usearch '<search query>'
```

## Minimal Search
Only returns the top summary and it's relevant document reference
```bash
$ ./ges-tool usearch '<search query>' -m
```

## CSV export of Search
Only returns the top summary and it's relevant document reference
```bash
$ ./ges-tool usearch '<search query>' -c
```
