#!/bin/bash

address=$(terraform state list)
for resource in $address; do
    echo "Removing Resource Address: $resource"
    terraform state rm "$resource"
    echo "_______Done_______"
done