#!/bin/bash

declare -A result

function saveAttributes() {
    local name
    local attrib
    local value
    IFS=' ' read -ra my_array <<< "$@"
    for item in "${!my_array[@]}"; do
        attrib="${my_array[$item]}"
        [[ "$attrib" == *=* ]] || continue
        name=${attrib%=*}
        value=${attrib#*=\'} 
        [[ "$value" == *\>* ]] && value=${value%\'\>} || value=${value%\'}
        result["$name"]="$value"
    done
}

orig="option type='submenu' id='preferences'>"


#findCommand=${orig#*'command="'}
#command=${findCommand%'" '*}

#findLink=${orig#*'link="'}
#link=${findLink%'" '*} || link=${findLink%'">'*}


printf "Init string:"
printf "$orig\n"
saveAttributes "$orig"
printf "Result:"
for key in "${!result[@]}"; do
    echo "$key ${result[$key]}"
done
#printf "$command\n"
#printf "$link\n"