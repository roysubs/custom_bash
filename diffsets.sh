#!/bin/bash

# Restart with a clean environment in case the file has been sourced
# previously. We need the absolute path in the shebang above for this.
[[ -v HOME ]] && exec -c "$0" "$@"

# We must use full paths without variables in case those variables
# are also set in the file we're about to source.
[[ -s "$1" ]] &&
mkdir -p "/usr/tmp/diffsets_$$" &&
trap '
    rm -f "/usr/tmp/diffsets_$$/old" "/usr/tmp/diffsets_$$/new" &&
    rmdir "/usr/tmp/diffsets_$$"
' 0 &&

# We want to only compare variables, not function definitions, but we
# can't use `set -o posix` as we need newlines printed as $'\n' instead
# of literal newline chars for later comparison so ensure posix is disabled
# and use awk to exit when the first function is seen as they always are
# printed after variables.

set +o posix &&
set | awk '$NF=="()"{exit} 1' > "/usr/tmp/diffsets_$$/old" &&

. "$1" &&

set +o posix &&
set | awk '$NF=="()"{exit} 1' > "/usr/tmp/diffsets_$$/new" &&

comm -13 "/usr/tmp/diffsets_$$/old" "/usr/tmp/diffsets_$$/new"
