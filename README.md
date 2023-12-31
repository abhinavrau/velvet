![](images/velvet_logo.png)

# Velvet 🔍 ✅ 
<u>Ve</u>rtex AI Search <u>Ve</u>rfication <u>T</u>ool

## Why?
Coz testing manually is hard, boring and no fun!
 
## Features
- Generates offline ranking metrics for Vertex AI Search. Takes a csv file with search queries and expected results to produce:
  - **Summary Precision**: semantically match using PaLM2 text-bison
  - Precision@0, Mean Average Precision (mAP), Mean Reciprocal Rank (MRR), Normalized Discounted Cumulative Gain (NDCG).  
  - Overall Summary precision and MRR with the ability to fail the script if these metrics fall below a specified threshold.
- Single Bash script [vlvt](vlvt) with minimal dependencies so its easy to use in the most restricted evironments. 
- Easy to make changes and integrate into your workflow for automated acceptance testing.
- Output to CSV, JSONL and to a human readable table format in the terminal for easy debugging.


## Limitations
  - Currently only supports unstructured search. 
  - Uses summary and first 2 documents search results to generate metrics.


## Examples
The folliwng use the Alphabet annual reports and 10K filings. See [this link](https://cloud.google.com/generative-ai-app-builder/docs/try-enterprise-search#create_and_preview_a_search_app_for_unstructured_data_from) on how to set it up.

Batch search AND verify with input file [verify_test_with_prompt.csv](test/data/verify_test_with_prompt.csv)  containing search queries with expected results and output results to a csv file.
```bash
./vlvt verify test/data/verify_test_with_prompt.csv --format=csv > verify_results.csv
```

Output as table format for humans
```bash
./vlvt verify test/data/verify_test_with_prompt.csv -f=table
```
![](images/verify_table.png)

Batch search with input file [batch_test_with_prompt.txt](test/data/batch_test_with_prompt.txt) containing search queries and output a table.
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
For command specific help
```bash
./vlvt <command> --help
```
## Development

1. Install [bashly](https://bashly.dannyb.co/installation/) 
2. Git clone this repo and change to the directory
3. To generate the vlvt script run:

```bash
bashly generate
```

4. Run the tests:
```bash
./test.sh
```