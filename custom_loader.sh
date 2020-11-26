#!/bin/bash

# - Add the loader line into .bashrc
# - Add lines to .vimrc
# - Add lines to .inputrc
# - Option to make actions load system wide
#   to /etc/bashrc, /etc/vimrc, /etc/inputrc
#  :


if [ -f ~/.custom ]; then
    if [[ $(find "~/.custom" -mtime +3 -print) ]]; then
        echo "File ~/.custom exists and is older than 3 days"
        echo "Backing up old .custom then downloading and dot sourcing new version"
        mv ~/.custom ~/.cutom.$(date +"%Y-%m-%d__%H-%M-%S")
        curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom
        . ~/.custom
    else
        . ~/.custom
    fi
else
    echo "No .custom was present: downloading and dot sourcing a new .custom file"
    curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom
    . ~/.custom
fi

# Find if file is older than 3 days ...
# if [[ $(find "~/.custom" -mtime +100 -print) ]]; then
#   echo "File ~/.custom exists and is older than 3 days"
# 
# fi
# Another is to use GNU date to do the math:
# 
# # collect both times in seconds-since-the-epoch
# hundred_days_ago=$(date -d 'now - 100 days' +%s)
# file_time=$(date -r "$filename" +%s)
# 
# # ...and then just use integer math:
# if (( file_time <= hundred_days_ago )); then
#   echo "$filename is older than 100 days"
# fi



##### .vimrc
# " No tabs (Ctrl-V<Tab> to get a tab), tab stops are 4 chars, indents are 4 chars
# set expandtab tabstop=4 shiftwidth=4


