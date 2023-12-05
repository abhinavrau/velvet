# shellcheck disable=SC2148
call_vertex_ai_search() {

    command_output=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${query}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 2}, "summarySpec":{"summaryResultCount": 3}} }') 
    error=$(echo "$command_output" | jq '.error.code' )
    if [ -z "$error" ]; then
        error_message=$(echo "$command_output" | jq '.error.message' )
        echo "Calling Vertex AI search failed. ErrorCode:$error ErrorMessage:$error_message"
        exit 1
    fi
    summary=$(echo "$command_output" | jq '.summary.summaryText' | sed 's/"//g')
    link_1=$(echo "$command_output" | jq '.results[0].document.derivedStructData.link' | sed 's/"//g' | xargs)
    link_2=$(echo "$command_output" | jq '.results[1].document.derivedStructData.link' | sed 's/"//g' | xargs) 
    link_3=$(echo "$command_output" | jq '.results[2].document.derivedStructData.link' | sed 's/"//g' | xargs) 
}