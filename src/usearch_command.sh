querystring=${args[query]}
page_size=${args[page_size]}
minimal=${args[--minimal]}
csv=${args[--csv]}
file=${args[--file]}

if [[ $minimal ]]; then
    curl -s  -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${querystring}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 5} } }' \
    | jq  '{summary: .summary.summaryText, link: .results[0].document.derivedStructData.link}' | ./jtbl
elif  [[ $csv ]]; then
    curl -s -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${querystring}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 5}} }' \
    | jq  '[{summary: .summary.summaryText, link: .results[0].document.derivedStructData.link}]' | ./jtbl -c
else
    curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${querystring}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 5} } }' 
fi

