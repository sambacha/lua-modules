Executable File  28 lines (22 sloc)  1.08 KB
  
#!/bin/bash

set -o pipefail
set -e

script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
. $script_dir/common.sh

echo -e "${cyan}Fetching Lua depedencies...${no_color}"
load_dependency () {
    local target="$1"
    local user="$2"
    local repo="$3"
    local commit="$4"
    local required_sha1="$5"

    local actual_sha1=$(cat $target | openssl sha1 | sed 's/^.* //')

    if [ -e "$target" ] && [ "$required_sha1" == "$actual_sha1" ]; then
        echo -e "Dependency $target (with SHA-1 digest $required_sha1) already downloaded."
    else
        curl https://codeload.github.com/$user/$repo/tar.gz/$commit | tar -xz --strip 1 $repo-$commit/lib
    fi
}
