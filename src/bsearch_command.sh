format=${args[--format]}
input_file=${args[input_file]}
token=${GCP_ACCESS_TOKEN}



if [ -z "$token" ]; then 
    token=$(gcloud auth print-access-token)
fi

output=""
while IFS= read -r line
 do
    if [ -z "$line" ]; then
        continue;
    else
        command_output=""
        query=$line
        call_vertex_ai_search
        summary=$(echo "$command_output" | jq '.summary.summaryText' | sed 's/"//g')
        link_1=$(echo "$command_output" | jq '.results[0].document.derivedStructData.link' | sed 's/"//g' )
        link_2=$(echo "$command_output" | jq '.results[1].document.derivedStructData.link' | sed 's/"//g' ) 
        link_3=$(echo "$command_output" | jq '.results[2].document.derivedStructData.link' | sed 's/"//g' ) 

        output+="{\"summary\": \"$summary\", \"link_1\": \"$link_1\", \"link_2\": \"$link_2\", \"link_3\": \"$link_3\"}"$'\n'

    fi
done < "$input_file"

format_output







