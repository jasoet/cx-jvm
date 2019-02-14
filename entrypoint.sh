#!/bin/bash

echo "##### Enable sdkman executable #####"
export SDKMAN_DIR="/root/.sdkman"
[[ -s "/root/.sdkman/bin/sdkman-init.sh" ]] && source "/root/.sdkman/bin/sdkman-init.sh"

echo "##### Execute Command! ${@} #####"
exec "$@"

