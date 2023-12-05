querystring=${args[query]}
format=${args[--format]}
file=${args[--file]}

token=${GCP_ACCESS_TOKEN}

if [ -z "$token" ]; then 
    token=$(gcloud auth print-access-token)
fi

command_output=""
query=$querystring
call_vertex_ai_search

output+="{\"summary\": \"$summary\", \"link_1\": \"$link_1\", \"link_2\": \"$link_2\", \"link_3\": \"$link_3\"}"$'\n'
format_output
