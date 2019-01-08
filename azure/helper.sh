#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail

repo_root="$( cd . "$(dirname "$0")" ; pwd -P )"

function convert_to_lowercase() {
    echo "Converting Parameters to Lowercase"

    resource_group_name=$(tr '[:upper:]' '[:lower:]' <<< $resource_group_name)
    environment=$(tr '[:upper:]' '[:lower:]' <<< $environment)
    location=$(tr '[:upper:]' '[:lower:]' <<< $password)
}
convert_to_lowercase
