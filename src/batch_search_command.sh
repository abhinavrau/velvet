page_size=${args[page_size]}
input_file=${args[input_file]}
output_file=${args[output_file]}

token=$(gcloud auth print-access-token)

output="["
echo "doing batch from ${input_file}"
while IFS= read -r line
 do
    if [ -z "$line" ]; then
        continue;
    else
        output+=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${line}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 5}} }' \
        | jq  '{summary: .summary.summaryText, link: .results[0].document.derivedStructData.link}') 
        output+=","
    fi
done < "$input_file"
output=${output::-1}
output+="]"
echo "$output" | ./jtbl -c > "${output_file}"




