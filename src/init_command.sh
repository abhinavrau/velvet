if [ -f "jtbl" ]; then
  echo "The jbtl tool is already installed."
else
  # Determine the platform.
  platform=$(uname -s)-$(uname -m)
  # to upper case
  platform_lower=${platform,,}  
  # Download the CLI tool for the current platform.
  curl -LO https://github.com/kellyjonbrazil/jtbl/releases/download/v1.5.2/jtbl-1.5.2-"${platform_lower}".tar.gz 
  tar -xvf jtbl-1.5.2-"${platform_lower}".tar.gz 
  rm jtbl-1.5.2-"${platform_lower}".tar.gz
  echo "The jbtl tool installed."
fi
echo "Checking for gcloud authetication"
token=$(gcloud auth print-access-token)
echo "gcloud auth succeeded."
