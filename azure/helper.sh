#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail

repo_root="$( cd . "$(dirname "$0")" ; pwd -P )"

function convert_to_lowercase() {
    echo "Converting Parameters to Lowercase"

    RESOURCE_GROUP_NAME=$(tr '[:upper:]' '[:lower:]' <<< $RESOURCE_GROUP_NAME)
    ENVIRONMENT=$(tr '[:upper:]' '[:lower:]' <<< $ENVIRONMENT)
    LOCATION=$(tr '[:upper:]' '[:lower:]' <<< $LOCATION)
}
convert_to_lowercase
