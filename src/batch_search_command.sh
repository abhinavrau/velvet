page_size=${args[page_size]}
input_file=${args[input_file]}

token=${GCP_ACCESS_TOKEN}

if [ -z "$token" ]; then 
    token=$(gcloud auth print-access-token)
fi

output="["
echo "doing batch from ${input_file}"
while IFS= read -r line
 do
    if [ -z "$line" ]; then
        continue;
    else
        command_output=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${line}"'", "page_size": "1", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 2}, "summarySpec":{"summaryResultCount": 3}} }') 
        error=$(echo "$command_output" | jq '.error.code' )
        if [ "$error" = '401' ]; then
            echo "Authentication failed."
            exit 1
        else
           output+=$(echo "$command_output" | jq  '{summary: .summary.summaryText, link_1: .results[0].document.derivedStructData.link, link_2: .results[1].document.derivedStructData.link, link_3: .results[2].document.derivedStructData.link}')
        fi
        output+=","
    fi
done < "$input_file"
output=${output::-1}
output+="]"
echo "$output" | ./jtbl -c




