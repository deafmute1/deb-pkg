#!/usr/bin/env bash
# Author: Ethan Djeric <me@ethandjeric.com> 
# Licensed under the terms of the GPL-3 (or newer version) 
# Files matching pattern /etc/interception/udevmon.d/deafmute-ppa-* are assumed to belong to packages and not the user by this script.
# Due to how binaries in the interception-tools package works, please be aware that additional user configurations 
# in /etc/interception/udevmon.d/* can interfere with the default configurations intended operation. 

#set -euxo pipefail
CONF_PREFIX="deafmute-ppa-"
CONF_SRC_DIR="/usr/share/interception-config/conf"
CONF_DEST_DIR="/etc/interception/udevmon.d" 

function deploy_config {
  if [[ ! -d "$CONF_DEST_DIR" ]]; then 
    mkdir -p "$CONF_DEST_DIR"
  fi 

  if [[ -f "${CONF_DEST_DIR}/${CONF_PREFIX}"* ]]; then 
    rm "${CONF_DEST_DIR}/${CONF_PREFIX}"* 
  fi 

  success=0
  plugins=$(dpkg-query --show 'interception*' | grep -v 'interception-tools' | cut -f1 | cut -f2 -d'-')
  plugins_c=$(wc -l <<< "$plugins")
  while read -r file; do
    file=$(basename "$file" .yaml)
    gotmatch=0
    while read -r plugin; do 
      if [[ "$file" == *"$plugin"* ]]; then 
        (( gotmatch += 1 ))
      else 
        break
      fi 
    done <<< "$plugins" 
    if (( gotmatch  == plugins_c )); then
      cp "${CONF_SRC_DIR}/${file}.yaml" "${CONF_DEST_DIR}/${CONF_PREFIX}${file}.yaml"
      echo "interception-config-updater: deployed config for following interception plugins $(tr "-" " " <<< "$file")"
      success=1
      break 
    fi 
  done < <(ls -v1 "$CONF_SRC_DIR")

  if (( success == 0 )); then
    echo "interception-config-updater: Failed to deploy new config"
  fi
}

while true; do 
  read -p "Would you like to install the recommended configurations for your specific installed interception plugins? [y/n]: " response 
  case $response in 
    "Y"|"y" ) 
      deploy_config
      break ;; 
    "N"|"n" ) 
      echo "interception-config-updater: Exiting"
      break ;; 
  esac
done 
