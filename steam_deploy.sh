#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Define the paths and inputs
steamdir=${STEAM_HOME:-$HOME/Steam}
contentroot=$(pwd)/${rootPath:-.}
buildOutputDir=$(pwd)/BuildOutput
vdfFilePath=$(pwd)/simple_app_build.vdf
appId=${appId:-1000}
depotId=${depotId:-$((appId + 1))}
depotPath=${depotPath:-.}

# Ensure the build output directory exists
mkdir -p "$buildOutputDir"

echo "#################################"
echo "#    Generating App Manifest    #"
echo "#################################"

# Generate the single VDF file
cat > "$vdfFilePath" <<EOF
"AppBuild"
{
	"AppID" "$appId" // your AppID
	"Desc" "$buildDescription" // internal description for this build
	"ContentRoot" "$contentroot" // root content folder, relative to location of this file
	"BuildOutput" "$buildOutputDir" // build output folder for build logs and build cache files
	"Depots"
	{
		"$depotId" // your DepotID
		{
			"FileMapping"
			{
				"LocalPath" "$depotPath/*" // all files from contentroot folder
				"DepotPath" "." // mapped into the root of the depot
				"recursive" "1" // include all subfolders
			}
		}
	}
}
EOF

# Output the VDF file to console for confirmation/logging
cat "$vdfFilePath"
echo ""


# Ensure steam_username and steam_password are set
: ${steam_username:?}
: ${steam_password:?}

# SteamGuard configuration
if [ -n "${steam_shared_secret:-}" ]; then
  echo "Using SteamGuard TOTP"
else  
  if [ ! -n "${configVdf:-}" ]; then
    echo "Config VDF input is missing or incomplete! Cannot proceed."
    exit 1
  fi
  steam_shared_secret="INVALID"
  echo "Copying SteamGuard Files..."
  mkdir -p "$steamdir/config"
  printf "%s" "$configVdf" | base64 -d > "$steamdir/config/config.vdf"
  chmod 777 "$steamdir/config/config.vdf"
fi

# Function to handle SteamCMD login and build upload
# Function to handle SteamCMD login and build upload with retries
execute_steamcmd() {
  local totp_code=""
  local totp_code_second=""
  local max_retries=5
  local attempt=1

  while [ $attempt -le $max_retries ]; do
    echo "Attempt $attempt of $max_retries..."

    if [ "$steam_shared_secret" != "INVALID" ]; then
      totp_code=$(node /root/get_totp.js "$steam_shared_secret")
      totp_code_second=$(node /root/get_totp.js "$steam_shared_secret" "5")

      if [ "$totp_code" != "$totp_code_second" ]; then
        totp_code=$totp_code_second
        sleep 6
      fi
    fi

    if steamcmd +login "$steam_username" "$steam_password" $totp_code "$@"; then
      echo "SteamCMD login successful on attempt $attempt."
      return 0
    else
      echo "SteamCMD login failed on attempt $attempt."
      attempt=$((attempt + 1))
      sleep 5
    fi
  done

  echo "SteamCMD login failed after $max_retries attempts."
  return 1
}

# Test login
echo "#################################"
echo "#        Test login             #"
echo "#################################"

if execute_steamcmd +quit; then
  echo "Successful login"
else
  echo "FAILED login"
  exit 1
fi

# Upload build
echo "#################################"
echo "#        Uploading build        #"
echo "#################################"

if ! execute_steamcmd +run_app_build "$vdfFilePath" +quit; then
  echo "Errors during build upload"
  echo ""
  echo "#################################"
  echo "#             Errors            #"
  echo "#################################"
  echo ""
  echo "Listing current folder and rootpath"
  echo ""
  ls -alh
  echo ""
  ls -alh "$rootPath" || true
  echo ""
  echo "Listing logs folder:"
  echo ""
  ls -Ralph "$steamdir/logs/"

  for f in "$steamdir"/logs/*; do
    if [ -e "$f" ]; then
      echo "######## $f"
      cat "$f"
      echo
    fi
  done

  echo ""
  echo "Displaying error log"
  echo ""
  cat "$steamdir/logs/stderr.txt"
  echo ""
  echo "Displaying bootstrapper log"
  echo ""
  cat "$steamdir/logs/bootstrap_log.txt"
  echo ""
  echo "#################################"
  echo "#             Output            #"
  echo "#################################"
  echo ""
  ls -Ralph BuildOutput

  for f in BuildOutput/*.log; do
    echo "######## $f"
    cat "$f"
    echo
  done
  exit 1
fi