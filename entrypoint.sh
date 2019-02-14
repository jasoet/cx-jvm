#!/bin/bash

export SDKMAN_DIR="/root/.sdkman"
 [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

$@
