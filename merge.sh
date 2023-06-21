#!/bin/bash
# ================================================================================
# Merge multiple netCDF files in time.
#
# The script will merge files that have a similar filename. Files are considered
# similar if their filenames before the last underscore match. For example,
# `file_1_a.nc` and `file_1_b.nc` are considered as one group and merged into
# `file_1.nc`. The merged files are saved in a subfolder named `merged`.
#
# Usage:
#    ./merge.sh [path]
#
# Options:
#   path      path to netCDF files
#
# Author: Andreas Groth
# ================================================================================

export SKIP_SAME_TIME=1 # skip duplicate time steps in mergetime

path=${1:-'.'}

outpath="$path/merged"
mkdir -p "$outpath"

# colors
color='\033[0;33m' # yellow
reset='\033[0m'    # color reset

# find unique filenames based on substring = prefix
declare -A prefixes=()
for infile in "$path"/*.nc; do
    # extract substring before last underscore
    inname=$(basename "$infile")
    prefix="${inname%_*}"

    # increment entry (strings of 1)
    prefixes[$prefix]+=1
done

N=${#prefixes[@]}
echo "Found $N group(s) in '$path'"

n=1
# merge files with same prefix
for prefix in "${!prefixes[@]}"; do
    echo -e "${color}$n/$N    Merge '$prefix*.nc': ${#prefixes[$prefix]} file(s) found.${reset}"

    outfile="$outpath/$prefix.nc"

    if [ -e "$outfile" ]; then
        ntime=$(cdo -s ntime "$outfile")
        npar=$(cdo -s npar "$outfile")
        echo "Skip '$outfile'. File already exists with $npar variables over $ntime timesteps."
    else
        cdo -f nc4 -z zip -r -mergetime "$path/$prefix"*.nc "$outfile"
    fi

    n=$((n + 1))
done
