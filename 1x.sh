def is a function
def () 
{ 
    if [ -z "$1" ]; then
        declare -F;
        printf "\nAbove listing is all defined functions 'declare -F' (use def <func-name> to show function contents)\nType 'alias' to show all aliases (def <alias-nam> to show alias definition, where 'def' uses 'command -V <name>')\n\n";
    else
        command -V $1;
    fi
}
