#!/bin/bash

## Import files
source read_xml.sh

## Declare variables
declare initialMenu
declare lastMenuID
declare optMax
declare -A selectedOptAttribs
currOpt=0

function ReadFileAndHighlight() {
    local FILE="$1"
    local highlight=$(( $2 + 7 )) # Static for now; subject to change
    local n=1

    while read line; do
        [[ n -eq highlight ]] && echo -e "\e[42;97m$line\e[0m" || echo "$line"   
        ((n++))  
    done < $FILE
}

function updateCurrentMenu() {
    local currentMenu="$1"
    lastMenuID="${menu[id]}"
    file="$MYTMPDIR/$currentMenu.txt"
    getMenu "xml/$currentMenu.xml" || echo "XML file is not available!"
}

function attributeLoop() {
    for key in "${!attributes[@]}"; do
        echo "$key ${attributes[$key]}"
    done
}

function saveAttributes() {
    local name
    local attrib
    local value
    IFS=' ' read -ra my_array <<< "$@"
    [[ -z "${my_array[@]}" ]] && return 1
    for item in "${!my_array[@]}"; do
        attrib="${my_array[$item]}"
        [[ "$attrib" == *=* ]] || continue
        name=${attrib%=*}
        value=${attrib#*=\'} 
        [[ "$value" == *\>* ]] && value=${value%\'\>} || value=${value%\'}
        selectedOptAttribs["$name"]="$value"
    done
}

function updateMenu() {
    saveAttributes "${attributes[$currOpt]}" || selectedOptAttribs[type]="back" 
    case "${selectedOptAttribs[type]}" in
        "submenu")
                    updateCurrentMenu "${selectedOptAttribs[id]}"
                    ;;
        "endpoint")
                    echo "this is where it ends.."
                    exit
                    ;;
        "back")
                    updateCurrentMenu "${menu[parent]}"
                    ;;
        *)
                    echo "wrong input.."
                    exit
                    ;;
    esac
}

## Initialize

## Temporary folder directory & generation of xml files
read -r MYTMPDIR initialMenu <<<$(./initialise_menu.sh)
trap 'rm -rf -- "$MYTMPDIR"' EXIT

## Main loop
updateCurrentMenu $initialMenu 

while [ ans != "" ]; do 
{
    optMax=${#options[@]}
    [ -f $file ] && ReadFileAndHighlight "$file" $currOpt
    [[ "${menu[parent]}" = "" ]] && ((optMax--)) 
    escape_char=$(printf "\u1b")
    read -rsn1 ans # get 1 character
    if [[ $ans == $escape_char ]]; then
        read -rsn2 ans # read 2 more chars
    fi
    case $ans in
        'q') 
                echo QUITTING ; exit ;;
        '[A') 
                [[ $currOpt -gt 0 ]] && ((currOpt--)) ;;
        '[B') 
                [[ $currOpt -lt $optMax ]] && ((currOpt++)) ;;
        '')     
                updateMenu
                currOpt=0 ;;
        *)      return ;;
    esac
}
done