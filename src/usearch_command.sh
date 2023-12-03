querystring=${args[query]}
page_size=${args[page_size]}
minimal=${args[--minimal]}
csv=${args[--csv]}
file=${args[--file]}

token=${GCP_ACCESS_TOKEN}

if [ -z "$token" ]; then 
    token=$(gcloud auth print-access-token)
fi

flag=''

if [[ $minimal ]]; then
    output=$(curl -s  -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${querystring}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 5} } }')
    use_jtbl=1
elif  [[ $csv ]]; then
    output=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${querystring}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 5}} }')
    flag='-c'
    use_jtbl=1
else
    output=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${querystring}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 5} } }')
fi

if [[ $output ]]; then
    error=$(echo "$output" | jq '.error.code' )
    if [ "$error" = '401' ]; then
        echo "Authentication failed with credentials in GCP_ACCESS_TOKEN"
        exit 1
    else
        if [[ $use_jtbl ]]; then 
            echo "$output" | jq  '[{summary: .summary.summaryText, link: .results[0].document.derivedStructData.link}]' | ./jtbl $flag
        else
            echo "$output"  
        fi
    fi
fi
