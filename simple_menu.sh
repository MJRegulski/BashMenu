#!/bin/bash

# Configuration
symbol="*"
padding_symbol=" "
padding_size=4
line_size=70

# checkWidth( options(array) )
#function checkWidth()


function header()
{
    generateBorder
    generateText "This is a test" "header"
    generateBorder
}

# generatePadding(amount)
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
    echo "$string"
}

# generateText (text, type)
function generateText()
{
    local border=1
    local characters=$line_size
    local padding=""
    if [ -n $2 ] && [ $2 = "header" ];
    then
            padding_size=$(($line_size / 2 - ${#1} / 2))
            padding=$(generatePadding $padding_size) 
            echo "$symbol$padding$1$padding$symbol"
    fi  
}

#function generateLine()

clear
header