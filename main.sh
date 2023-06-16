#!/bin/bash

# Import files
source read_xml.sh

# Declare variables
declare initialMenu
declare currentMenu
declare optMax
currentOpt=1

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
    currentMenu="$1"
    file="$MYTMPDIR/$currentMenu.txt"
    getMenu "xml/$currentMenu.xml"
}

# Initialize

## Temporary folder directory & generation of xml files
#MYTMPDIR=$(./initialise_menu.sh) || exit 1
read -r MYTMPDIR initialMenu <<<$(./initialise_menu.sh)
echo $MYTMPDIR $initialMenu
trap 'rm -rf -- "$MYTMPDIR"' EXIT


# Main loop
updateCurrentMenu $initialMenu 

while [ ans != "" ]; do 
{
    #optMax=$(( ${#options[@]} + 1 ))
    optMax=${#options[@]}
    #clear
    [ -f $file ] && ReadFileAndHighlight "$file" $currOpt
    escape_char=$(printf "\u1b")
    read -rsn1 ans # get 1 character
    if [[ $ans == $escape_char ]]; then
        read -rsn2 ans # read 2 more chars
    fi
    case $ans in
        'q') echo QUITTING ; exit ;;
        '[A') [[ $currOpt -gt 0 ]] && ((currOpt--)) ;;
        '[B') [[ $currOpt -lt $optMax ]] && ((currOpt++)) ;;
        '')     echo "ENTER! Option picked: ${options[$(( $currOpt -1 ))]}";
                updateCurrentMenu "${options[$(( $currOpt -1 ))]}"
                #exit
                ;;
        *) >&2 echo 'ERR bad input'; return ;;
    esac
}
done

