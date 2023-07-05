querystring=${args[query]}
page_size=${args[page_size]}
#echo ${query}
curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${querystring}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 2,"referenceOnly": false}, "extractiveContentSpec": {"maxExtractiveSegmentCount": 1} } }' \
| jq -r '[.results[0].document.derivedStructData.link, .results[0].document.derivedStructData.snippets[0].snippet] | @csv'