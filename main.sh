#!/bin/bash


highlight=7

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



#while [ ans != "" ]; do
#{
#    clear
#    [ -f file.txt ] && ReadFileAndHighlight file.txt $highlight
#
#    escape_char=$(printf "\u1b")
#    read -rsn1 ans # get 1 character
#    if [[ $ans == $escape_char ]]; then
#        read -rsn2 ans # read 2 more chars
#    fi
#    case $ans in
#        'q') echo QUITTING ; exit ;;
#        '[A') ((highlight--)) ;;
#        '[B') ((highlight++)) ;;
#        *) >&2 echo 'ERR bad input'; return ;;
#    esac
#}
#done