#!/bin/bash

# Quick notes:
# - check tput for inputing colours; example = lightblue=$(tput setaf 123)
# - optimise generateText option for shorter execution (PRIORITY)

# Configuration
symbol="*"
padding_symbol=" "
fg_colour=97
bg_colour=40
#bgc="\e${bg_colour}m"
#fgc="\e${fg_colour}m"
endc="\e[0m"
padding_size=4
line_size=70
longest_text=0

# user variables
declare -a options
declare title

# checkWidth( options(array) )
function checkWidth()
{
    local size=0
    local options=("$@")
    ## get length of $options array
    local len=${#options[@]}
    for (( i=0; i<$len; i++ )); do
    {
        local item=${options[i]}
        ## compare current value to last
        if [[ ${#item} -gt size ]]; then size=${#item} ; fi
    }
    done
    echo $size 
}

# header ( title )
function header()
{
    generateBorder
    generateText  
    generateText "header" "$title"
    generateText
    generateBorder
}

# body ( options(array) )
function body()
{
    generateText
    generateOptions
    generateText
    generateBorder
}

# generatePadding( amount )
function generatePadding()
{
    local string=""
    for (( i=0; i < $1; i++ )); do
        string+="$padding_symbol";
    done
    echo "$string"
}

function generateBorder()
{
    local string=""
    for (( i=0; i < line_size; i++ )); do
      string+="$symbol";
    done
    echo -e "$string"
}

# generateText ( type, text )
function generateText()
{
    local border_width=1
    local padding_remaining=0
    local characters=$(( $line_size - $border_width*2))
    local padding=$padding_size
    local padLeft=""
    local padRight=""
    local border=$symbol
    if [[ $1 = "header" ]]; then
        padding=$(( ($characters - ${#2} ) / 2 ))
    fi
    # used for empty space - echo "$border$(generatePadding $characters)$border"
    ## set up remaining padding
    padding_remaining=$(( $characters - $padding - ${#2}))
    padLeft=$(generatePadding $padding)
    padRight=$(generatePadding $padding_remaining)
    ## echo the result
    echo "$border$padLeft$2$padRight$border"
}

# generateOptions( options(array) )
function generateOptions()
{
    local size=0
    local index=1
    for item in "${options[@]}" 
    do
        generateText "options" "$index. $item"
        ((index++))
    done
}

# generateMenu( title, options(array) )
function generateMenu()
{
    ## save user variables
    options=("${@:2}")
    title=$1
    clear
    header
    body 
    echo 
    #longest_text=$(checkWidth "${options[@]}")
}

# Testing ground!
opt=("Siemens" "Allen Bradley" "ABB" "Omron" "Delta" "Honeywell" "GeFanuc" "Schneider Electric" "WAGO")
plc="Top PLC brands"
generateMenu "${plc}" "${opt[@]}"