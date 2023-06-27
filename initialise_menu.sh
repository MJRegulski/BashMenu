#!/bin/bash

## Import files
source read_xml.sh

## Declare variables
declare initialMenu

## Create temporary folder
MYTMPDIR=$(mktemp -d) || exit 1

isChild=0
## Pull all xml files from given directory (default folder: xml)
dir=xml
for xmlfile in "$dir"/*
    do
    getMenu "$xmlfile"
    [[ "${menu[parent]}" = "" ]] && initialMenu="${menu[id]}" || isChild=1
    echo "$(./generate_menu.sh "${menu[title]}" $isChild "options" "${options[@]}" )" > "$MYTMPDIR/${menu[id]}".txt
    #echo "$(./generate_menu.sh "${menu[title]}" $isChild "${options[@]}")" > "$MYTMPDIR/${menu[id]}".txt
done

## Return values
echo $MYTMPDIR $initialMenu
