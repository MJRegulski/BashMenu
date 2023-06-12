#!/bin/bash

# Quick notes:
# - check tput for inputing colours; example = lightblue=$(tput setaf 123)
# - optimise generateText option for shorter execution (PRIORITY)

# include xml file script
source read_xml.sh

# Configuration
symbol="*"
padding_symbol=" "
padding_size=4
line_size=70
border_width=1

declare border
declare empty_line
declare -i longest_text

# user variables
options=("${@:2}")
title="$1"

# checkWidth( options(array) )
function checkWidth() {
    local size=0
    ## get length of $options array
    local len=${#options[@]}
    for (( i=0; i<$len; i++ )); do 
        local item=${options[i]}
        ## compare current value to last
        if [[ ${#item} -gt size ]]; then size=${#item} ; fi
    done
    echo $size
}

# header ( title )
function header() {
    ## generate known lines
    border=$(generateBorder)
    empty_line=$(generateText)  
    ## echo header
    echo "$border"
    echo "$empty_line"
    generateText "header" "$title"
    echo "$empty_line"
    echo "$border"
}

# body ( options(array) )
function body() {
    echo "$empty_line"
    generateOptions
    echo "$empty_line"
    echo "$border"
}

# generatePadding( amount )
function generatePadding() {
    local string=""
    for (( i=0; i < $1; i++ )); do
        string+="$padding_symbol";
    done
    ## echo the result
    echo "$string"
}

function generateBorder() {
    local string=""
    for (( i=0; i < line_size; i++ )); do
      string+="$symbol";
    done
    ## echo the result
    echo -e "$string"
}

# generateText ( type, text )
function generateText() {
    local padding_remaining=0
    local characters=$(( $line_size - $border_width*2))
    local padding=$padding_size
    local padLeft=""
    local padRight=""
    local border=$symbol
    if [[ $1 = "header" ]]; then
        padding=$(( ($characters - ${#2} ) / 2 ))
    fi 
    ## set up remaining padding
    padding_remaining=$(( $characters - $padding - ${#2}))
    padLeft=$(generatePadding $padding)
    padRight=$(generatePadding $padding_remaining)
    ## echo the result
    echo "$border$padLeft$2$padRight$border"
}

# generateOptions( options(array) )
function generateOptions() {
    local index=1
    for item in "${options[@]}"; do
        generateText "options" "$index. $item"
        ((index++))
    done
}

# generateMenu( title, options(array) )
function generateMenu() {
    ## save user variables
    #options=("${@:2}")
    #title=$1
    clear
    header
    body  
    #longest_text=$(checkWidth "${options[@]}")
}

## Main
generateMenu