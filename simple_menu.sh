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


function header()
{
    generateBorder
    generateText  
    generateText "header" " Chyba dzialo "
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

# generateText ( text, type )
function generateText()
{
    local border_width=1
    local padding_size=0
    local padding_remaining=0
    local characters=$(( $line_size - $border_width*2))
    local padLeft=""
    local padRight=""
    local border=$symbol
    case $1 in
        "header")
            padding_size=$(( ($characters - ${#2} ) / 2 ))
            padding_remaining=$(( $characters - $padding_size - ${#2}))
            padLeft=$(generatePadding $padding_size)
            padRight=$(generatePadding $padding_remaining)
            echo "${gbc}$border$padLeft$2$padRight$border"
            ;;
        "option")
            ;;
        "settings")
            ;;

        *)
            echo "${gbc}$border$(generatePadding $characters)$border"
            ;;
    esac
}

# generateOptions( options(array) )
function generateOptions()
{
    local size=0
    local options=("$@")
    local index=1
    for item in $options 
    do
        echo "$index.$item"
        (($index++))
    done
}

# generateMenu( title, options(array), type )
function generateMenu()
{
    clear
    header
    options=("one" "two" "three" "four" "heehehehehe" "one")
    longest_text=$(checkWidth "${options[@]}")
}

# Testing ground!
generateMenu