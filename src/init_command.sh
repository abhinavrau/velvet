if [ -f "jtbl" ]; then
  echo "The jbtl tool is already installed."
else
  
  os=$(uname -s)
  arch=$(uname -m)

  # For macOS stick to x86 since no arm build yet.
  if [ "$arch" == "Darwin" ]; then
      arch="x86_64"
  fi

  # Determine the platform.
  platform="$os"-"$arch"
  # to lower case
  platform_lower=${platform,,}  
  
   # Destination file to save the downloaded content
  file_path=jtbl-1.5.2-"${platform_lower}".tar.gz

  url=https://github.com/kellyjonbrazil/jtbl/releases/download/v1.5.2/jtbl-1.5.2-"${platform_lower}".tar.gz

  # Use curl to download the file
  response_code=$(curl -s -LO "$url" -w "%{http_code}")

  # Check the HTTP status code
  if [ "$response_code" -eq 200 ]; then
    echo "File $file_path downloaded successfully (HTTP status code: $response_code)."
    echo "The jbtl tool installed."
    # You can further process the downloaded file or display a success message.
  else
    echo "File download failed (HTTP status code: $response_code)."
    echo "The jbtl tool NOT installed. Check you have an internet connection."
    exit 1
    # Handle the error or display an error message.
  fi
  tar -xzf "$file_path" 
  rm "$file_path"
fi
echo "Checking for gcloud authetication"
token=$(gcloud auth print-access-token)
echo "gcloud auth succeeded."
