#!/bin/bash

# TO DO:
# - add function to save attributes

declare -A menu
declare -a options

## used to extract individual parameters from menu item
function read_param() {
    read -d "=" ATTRIBUTE VALUE
}

# read_dom( FILE )
function read_dom() {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

# get_menu( )
function get_menu() {
    local FILE=$1
    while read_dom; do
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

############################################
# How to loop through keys & values in menu:
for key in "${!menu[@]}"; do
    echo "$key ${menu[$key]}"
done
############################################