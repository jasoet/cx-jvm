#!/bin/bash

echo "##### Enable sdkman executable #####"
export SDKMAN_DIR="/root/.sdkman"
[[ -s "/root/.sdkman/bin/sdkman-init.sh" ]] && source "/root/.sdkman/bin/sdkman-init.sh"

echo "##### Execute Command! ${@} #####"
if [[ -x /usr/local/bin/bash ]]; then
    exec /usr/local/bin/bash $@
elif [[ -x /usr/bin/bash ]]; then
    exec /usr/bin/bash $@
elif [[ -x /bin/bash ]]; then
    exec /bin/bash $@
elif [[ -x /usr/local/bin/sh ]]; then
    exec /usr/local/bin/sh $@
elif [[ -x /usr/bin/sh ]]; then
    exec /usr/bin/sh $@
elif [[ -x /bin/sh ]]; then
    exec /bin/sh $@
else
    echo shell not found
    exit 1
fi

