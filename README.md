# Velvet 🔍 ✅ 
🔮 <u>Ve</u>rtex AI Search <u>Ve</u>rfication <u>T</u>ool

## Why?
For offline evaluation metric creation for Vertex AI Search
 
## Features
- Call [Vertex AI Search](https://cloud.google.com/enterprise-search) API from the command line
- Output to CSV, JSONL and to a human readable table format.
- Batch verification for Acceptance testing with CSV file with queries and expected summary and document links and produces:
  - **Summary Precision**: semantically match using PaLM2 text-bison
  - Precision@0, Mean Average Precision (mAP), Mean Reciprocal Rank (MRR), Normalized Discounted Cumulative Gain (NDCG).  
  - Overall Summary precision and MMR with ability to fail the script if below threshold.
- Single Bash script [vlvt](vlvt) with minimal dependencies so its easy to make changes and integrate into your workflow.

## Limitations
  - Currently only supports unstructured search.


## Examples
The folliwng use the Alphabet annual reports and 10K filings. See [this link](https://cloud.google.com/generative-ai-app-builder/docs/try-enterprise-search#create_and_preview_a_search_app_for_unstructured_data_from) on how to set it up.

Batch search AND verify with input file [verify_test_with_prompt.csv](test/datatest/data/verify_test_with_prompt.csv)  containing search queries with expected results and output results to a csv file.
```bash
./vlvt verify test/data/verify_test_with_prompt.csv --format=csv > verify_results.csv
```

Output as table format for humans
```bash
./vlvt verify test/data/verify_test_with_prompt.csv -f=table
```
![](images/verify_table.png)

Batch search with input file [batch_test_with_prompt.txt](test/datatest/data/batch_test_with_prompt.txt) containing search queries and output a table.
```bash
./vlvt bsearch test/datatest/data/batch_test_with_prompt.txt -f=csv > batch_results.csv
```

Single search with table output.
```bash
./vlvt search "You are expert financial analyst. Be terse. Answer the question with minimal facts. What is Google's revenue for year ending 2022?" --format=table
```
![](images/search_table.png)

Single search with csv output.
```bash
./vlvt search "You are expert financial analyst. Be terse. Answer the question with minimal facts. What is Google's revenue for year ending 2022?" --format=csv > batch_output.csv

```
Single search with jsonl output
```bash
./vlvt search "You are expert financial analyst. Be terse. Answer the question with minimal facts. What is Google's revenue for year ending 2022?" -f=jsonl > batch_output.jsonl

```


## Install

### Prequesities
  - bash shell v4+
  - curl
  - jq
  - gcloud
  - Linux or macOS
  

Clone this repo or just copy the [vlvt](./vlvt) to your local  machine with bash support. Open termnial and change the permission to make it executable

```bash
chmod +x ./vlvt
```

## Setup

1. For MacOS users please ensure you have bash v4+ installed. To check run 
```bash
bash --version
```
To upgrade follow direction [here](https://itnext.io/upgrading-bash-on-macos-7138bd1066ba)

1. Setup [gcloud](https://cloud.google.com/sdk/docs/install-sdk) cli and authenticate to make sure you have access to the project with ES you want to query

2. Create Vertex AI search app. See [here](https://cloud.google.com/generative-ai-app-builder/docs/try-enterprise-search#create_and_preview_a_search_app_for_unstructured_data_from) on how to create one with all the Alphabet earnings reports pdfs. 

3. Export the following env variables.

```bash
$ export VAI_SEARCH_PROJECT_NUMBER=<vertex-ai-search-gcp-project-number> # Project Number of the Vertex AI Search Engine
$ export VAI_SEARCH_DATASTORE_NAME=<vertex-ai-search-search_datastore_name>  # Datastore ID of the Vertex AI Search Engine
$ export TEXT_BISON_PROJECT_ID=<palm-text-bison-project-id> # used by verify command to match summaries 
$ export TEXT_BISON_LOCATION_ID=<palm-text-bison-region-name> # used by verify command to match summaries 
```
3. Install dependent tools. 

```bash
./vlvt init
```
This installs [jtbl](https://github.com/kellyjonbrazil/jtbl) and verifies gcloud auth.

## Full Usage
```bash
./vlvt --help
```
## Development

1. Install [bashly](https://bashly.dannyb.co/installation/) 
2. Git clone this repo and change to the directory
3. Generate the vlvt script 

```bash
bashly generate
```

4. Run the tests
```bash
./test.sh
```