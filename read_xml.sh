#!/bin/bash

# TO DO:
# - add function to save attributes

declare -A menu
declare -a attributes
declare -a options

xmlFileLocation="./xml/"
declare file

## used to extract individual parameters from menu item
function saveAttributes() {
    local findAttribute=${$@#*'="'}
}

# readDom( FILE )
function readDom() {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

function extractData() {
    menu=[]
    options=()
    attributes=()
    while readDom; do
        ## comparator checks if entity contains a phrase
        case $ENTITY in
        "title")
            menu[title]="$CONTENT"
            ;;
        "parent")
            menu[parent]="$CONTENT"
            ;;
        "id")
            menu[id]="$CONTENT"
            ;;
        "option"*)
            options+=( "$CONTENT" )
            attributes+=( "$ENTITY" )
            ;;
        *)
            ;;
        esac
    done < $FILE
}

# getMenu( )
function getMenu() {
    FILE="$1"
    [[ -f $FILE ]] && extractData ||  exit 1 
}


############################################
# How to loop through keys & values in menu:
#for key in "${!menu[@]}"; do
#    echo "$key ${menu[$key]}"
#done
############################################