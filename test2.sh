#!/bin/bash

function saveAttributes() {
    local orig=$@
    IFS=' ' read -ra my_array <<< "$orig"
    #local findAttribute=${orig#*'="'}
    for item in "${!my_array[@]}"; do
        echo "$item ${my_array[$item]}"
    done
}


orig='option command="echo Hello World"'
findCommand=${orig#*'command="'}
command=${findCommand%'" '*}

findLink=${orig#*'link="'}
link=${findLink%'" '*} || link=${findLink%'">'*}


printf "Result:\n"
printf "$orig\n"
saveAttributes "$orig"
#printf "$command\n"
#printf "$link\n"