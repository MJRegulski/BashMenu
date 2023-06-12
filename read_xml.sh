#!/bin/bash

# TO DO:
# - add function to save attributes

declare -A menu
declare -a options

xmlFileLocation="./xml/"
declare file

## used to extract individual parameters from menu item
function readParam() {
    read -d "=" ATTRIBUTE VALUE
}

# readDom( FILE )
function readDom() {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

function extractData() {
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
            ;;
        *)
            ;;
        esac
    done < $FILE
}

# getMenu( )
function getMenu() {
    FILE="$1"
    [[ -f $FILE ]] && extractData ||  exit 0 
}


############################################
# How to loop through keys & values in menu:
#for key in "${!menu[@]}"; do
#    echo "$key ${menu[$key]}"
#done
############################################