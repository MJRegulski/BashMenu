#!/bin/bash

# Import files
source read_xml.sh

# Declare variables
declare initialMenu
percentage=0
highlight=7

# CheckIfFileExists( location=(path/file) )
function CheckIfFileExists()
{
    if [ -f "$1" ]; then
        echo "File exists."
    else
        echo "File does not exist."
    fi  
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

# Main
clear
echo "Loading menu..."

mkdir tmp

dir=xml
for xmlfile in "$dir"/*
do
    echo "$xmlfile"
    getMenu "$xmlfile"
    [[ "${menu[parent]}" = "" ]] && initialMenu="${menu[id]}"
    echo "$(./generate_menu.sh "${menu[title]}" "${options[@]}")" > "tmp/${menu[id]}".txt
done

echo "initial menu is: $initialMenu"

while [ ans != "" ]; do
{
    clear
    file="tmp/$initialMenu.txt"
    [ -f $file ] && ReadFileAndHighlight "$file" $highlight

    escape_char=$(printf "\u1b")
    read -rsn1 ans # get 1 character
    if [[ $ans == $escape_char ]]; then
        read -rsn2 ans # read 2 more chars
    fi
    case $ans in
        'q') echo QUITTING ; rm -r tmp ; exit ;;
        '[A') ((highlight--)) ;;
        '[B') ((highlight++)) ;;
        *) >&2 echo 'ERR bad input'; return ;;
    esac
}
done
