# Helper function to calculate MRR@K
function mrr_at_k_helper {
  actual_link_1=$1
  actual_link_2=$2
  expected_link_1=$3
  expected_link_2=$4

  # Check if the actual document links are in the search results
  if [[ ! " $("$@")

  # Check if the expected document links are in the search results
  if [[ ! " ${document_links[@]}" =~ " $link_1 " ]]; then
    return 0
  fi

  if [[ ! " ${document_links[@]}" =~ " $link_2 " ]]; then
    return 0
  fi

  # Calculate the reciprocal rank of the expected document links
  rank_1=$(expr $(echo "${document_links[@]}" | grep -n "$link_1" | cut -d':' -f1) + 1)
  rank_2=$(expr $(echo "${document_links[@]}" | grep -n "$link_2" | cut -d':' -f1) + 1)

  # Calculate the MRR@K score
  mrr_at_k=$(expr 1 / ($rank_1 + $rank_2))

  return $mrr_at_k
}