#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    usage
fi

docker exec -it $1 /bin/bash