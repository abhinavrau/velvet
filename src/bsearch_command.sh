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
       
        query=$line
        call_vertex_ai_search

        output+="{\"summary\": \"$summary\", \"link_1\": \"$link_1\", \"link_2\": \"$link_2\", \"link_3\": \"$link_3\"}"$'\n'

    fi
done < "$input_file"

format_output







