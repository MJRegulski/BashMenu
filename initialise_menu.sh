#!/bin/bash

# Import files
source read_xml.sh

# Declare variables
declare initialMenu
percentage=0

declare optMax
currOpt=1

# CheckIfFileExists( location=(path/file) )
function CheckIfFileExists() {
    if [ -f "$1" ]; then
        echo "File exists."
    else
        echo "File does not exist."
    fi  
}

function ReadFileAndHighlight() {
    local FILE="$1"
    local highlight=$(( $2 + 6 )) # Static for now; subject to change
    local n=1

    while read line; do
        [[ n -eq highlight ]] && echo -e "\e[42;97m$line\e[0m" || echo "$line"   
        ((n++))  
    done < $FILE
}

function RemoveTmp() {
    [[ -d 'tmp' ]] && rm -r tmp
}

# Main
clear
echo "Loading menu..."
## Create temporary folder
mkdir tmp
## Pull all xml files from given directory (default folder: xml)
dir=xml
for xmlfile in "$dir"/*
do
    echo "Processing: $xmlfile"
    getMenu "$xmlfile"
    [[ "${menu[parent]}" = "" ]] && initialMenu="${menu[id]}"
    echo "$(./generate_menu.sh "${menu[title]}" "${options[@]}")" > "tmp/${menu[id]}".txt
done

echo "initial menu is: $initialMenu"

while [ ans != "" ]; do 
{
    file="tmp/$initialMenu.txt"     # call once at start, then with new var (currentMenu)
    getMenu "xml/$initialMenu.xml"  # call on every menu change
    optMax=${#options[@]}

    clear
    [ -f $file ] && ReadFileAndHighlight "$file" $currOpt
    escape_char=$(printf "\u1b")
    read -rsn1 ans # get 1 character
    if [[ $ans == $escape_char ]]; then
        read -rsn2 ans # read 2 more chars
    fi
    case $ans in
        'q') echo QUITTING ; RemoveTmp ; exit ;;
        '[A') [[ $currOpt -gt 1 ]] && ((currOpt--)) ;;
        '[B') [[ $currOpt -lt $optMax ]] && ((currOpt++)) ;;
        '') echo "ENTER! Option picked: ${options[$(( $currOpt -1 ))]}" ; RemoveTmp ; exit ;;
        *) >&2 echo 'ERR bad input'; return ;;
    esac
}
done
