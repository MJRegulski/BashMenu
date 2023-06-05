#!/bin/bash

# This is a simple testing platform

# Array parsing testing
function PrintArray()
{
    local arr=("${@}")
    echo ${arr[1]}
}

#array=("Hi" "there" "mate")
#PrintArray "${array[@]}"

# CheckIfFileExists( location=(path/file) )
function CheckIfFileExists()
{
    if [ -f "$1" ]; then
        echo "File exists."
    else
        echo "File does not exist."
    fi  
}

# ReadFile( filename )
function ReadFile()
{
    local FILE="$1"

    while read line; do
        echo "$line"
    done < $FILE
}

function ReadFileAndHighlight()
{
    local FILE="$1"
    local highlight=$2
    local n=1

    while read line; do
        [[ n -eq highlight ]] && echo -e "\e[42;97m$line\e[0m" || echo "$line"   
        ((n++))  
    done < $FILE
}


# importing other files
source simple_menu.sh
clear
echo "Loading menu..."

highlight=7

while [ ans != "" ]; do
{
    clear
    [ -f file.txt ] && ReadFileAndHighlight file.txt $highlight || { echo "$(generateMenu)" > file.txt && continue } 

    escape_char=$(printf "\u1b")
    read -rsn1 ans # get 1 character
    if [[ $ans == $escape_char ]]; then
        read -rsn2 ans # read 2 more chars
    fi
    case $ans in
        'q') echo QUITTING ; exit ;;
        '[A') ((highlight--)) ;;
        '[B') ((highlight++)) ;;
        *) >&2 echo 'ERR bad input'; return ;;
    esac
}
done