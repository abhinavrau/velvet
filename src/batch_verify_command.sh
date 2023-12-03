#inspect_args
input_file=${args[input_file]}
token=${GCP_ACCESS_TOKEN}

if [ -z "$token" ]; then 
    token=$(gcloud auth print-access-token)
fi

# Check if the file exists
if [ ! -f "$input_file" ]; then
  echo "File not found: $input_file"
  exit 1
fi

# Read the CSV file line by line
read -r header < "$input_file" # Read the first line as header
column_names=($(echo "$header" | tr ',' '\n')) # Split header into array based on comma delimiter

# Verify column names or take any actions based on them
expected_columns=("id" "query" "expected_summary" "expected_document_link_1" "expected_document_link_2") # Define expected column names
if [ "${#column_names[@]}" -ne "${#expected_columns[@]}" ]; then
  echo "Column count doesn't match!"
  exit 1
fi

for ((i = 0; i < ${#expected_columns[@]}; i++)); do
  if [ "${column_names[$i]}" != "${expected_columns[$i]}" ]; then
    echo "Column '${expected_columns[$i]}' not found!"
    exit 1
  fi
done

ids=()
queries=()
expected_summaries=()
expected_document_links_1=()
expected_document_links_2=()

# Read the rest of the rows and store individual fields in arrays
while IFS=',' read -r id query expected_summary expected_document_link_1 expected_document_link_2 ; do
  ids+=("$id")
  queries+=("$query")
  expected_summaries+=("$expected_summary")
  expected_document_links_1+=("$expected_document_link_1")
  expected_document_links_2+=("$expected_document_link_2")
done < <(tail -n +2 "$input_file")


output="["
# Display or process the arrays 
for ((i = 0; i < ${#ids[@]}; i++)); do
  #echo "ID: ${ids[$i]}, query: ${queries[$i]}, expected_summary: ${expected_summaries[$i]}, expected_document_link: ${expected_document_links[$i]}"
  # Skip line with empty id field
  if [ -z "${ids[$i]}" ]; then
      continue;
  else
      current_id="${ids[$i]}"
      expected_link_1="${expected_document_links_1[$i]}"
      expected_link_2="${expected_document_links_2[$i]}"

      command_output=$(curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://discoveryengine.googleapis.com/v1alpha/projects/${GCP_PROJECT_NUMBER}/locations/global/collections/default_collection/dataStores/${DATASTORE_NAME}/servingConfigs/default_search:search" -d '{ "query": "'"${queries[$i]}"'", "page_size": "5", "offset": 0 , "contentSearchSpec": { "snippetSpec":{"maxSnippetCount": 3}, "summarySpec":{"summaryResultCount": 3}} }') 
      error=$(echo "$command_output" | jq '.error.code' )
      if [ "$error" = '401' ]; then
          echo "Authentication failed."
          exit 1
      else
          summary_to_match=$(echo "$command_output" | jq '.summary.summaryText' | sed 's/"//g')
          actual_link_1=$(echo "$command_output" | jq '.results[0].document.derivedStructData.link' | sed 's/"//g' )
          actual_link_2=$(echo "$command_output" | jq '.results[1].document.derivedStructData.link' | sed 's/"//g' ) 

          if [ "$actual_link_1" == "${expected_document_links_1[$current_id]}" ]; then
             link_1_match="matched"
          else 
             link_1_match="not_matched"
          fi

          if [ "$actual_link_2" == "${expected_document_links_2[$current_id]}" ]; then
             link_2_match="matched"
          else 
             link_2_match="not_matched"
          fi
        
          expected_summary=${expected_summaries[$i]}
            # Verify the summary by calling text-bison
          prompt="You will get two answers to a question, you should determine if they are semantically similar or not. 
            examples - answer_1: I was created by X. answer_2: X created me. output:same 
            answer_1:There are 52 days in a year. answer_2: A year is fairly long. output:different"
          full_payload=$prompt" Now answer answer_1: $summary_to_match,
              answer_2: $expected_summary
              output:"

          jsonPayload="   
          {
                  \"instances\": [
                      {
                          \"content\": \"${full_payload}\"
                      }
                  ],
                  \"parameters\": {
                      \"candidateCount\": 1,
                      \"maxOutputTokens\": 1024,
                      \"temperature\": 0.2
                  }
          }"
          #echo "$jsonPayload"
          
          API_ENDPOINT="${LOCATION_ID}-aiplatform.googleapis.com"
          MODEL_ID="text-bison"

          match_result=$(curl \
          -s \
          -X POST \
          -H "Authorization: Bearer $token" \
          -H "Content-Type: application/json" \
          "https://${API_ENDPOINT}/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/publishers/google/models/${MODEL_ID}:predict" -d "$jsonPayload")

          summary_match=$(echo "$match_result" | jq '.predictions[0].content' | sed 's/"//g')

          output+="{\"id\": \"$current_id\", \"actual_summary\": \"$summary_to_match\", \"expected_summary\": \"$expected_summary\", \"summary_match\": \"$summary_match\" , \"expected_link_1\": \"$expected_link_1\"  ,  \"actual_link_1\": \"$actual_link_1\", \"link_1_match\": \"$link_1_match\", \"expected_link_2\": \"$expected_link_2\" ,  \"actual_link_2\": \"$actual_link_2\"  ,\"link_2_match\": \"$link_2_match\"}"
          
      fi
      output+=","
  fi
done

# remove the last comma
output=${output::-1}
# close the array
output+="]"

echo "$output" | ./jtbl -c
