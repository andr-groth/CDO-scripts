#!/bin/bash
# =============================================================================
# Get individual PCs from multiple files.
#
# The netCDF files are projected onto the given EOFs to obtain the PCs.
#
# The first argument EOFFILE is the netCDF file with the EOFs and the remaining
# arguments are the netCDF files that are projected onto the EOFs. The PCs are
# saved in the folder of EOFFILE.
#
# Usage:
#    ./get_pcs.sh EOFFILE INFILES
#
# Author: Andreas Groth
# =============================================================================

# path of temporay files
tmppath="./_tmp/get_pcs_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$tmppath"

# colors
color='\033[0;33m' # yellow
reset='\033[0m'    # color reset

# needed for setzaxis
zaxis="$tmppath/zaxis"
echo -e "zaxistype = height\nsize = 1\nlevels = 1" >"$zaxis"

echo "================================================================================"
echo "Calculate PCs for $(($# - 1)) file(s) projected onto '$1'"

outpath=$(dirname "$1")

n=1
N=$(($# - 1))
for infile in "${@:2}"; do
    echo "--------------------------------------------------------------------------------"
    echo -e "${color} $n/$N    Project '${infile}'${reset}"

    inname=$(basename "$infile")

    # project, creates separate files for each PC
    tmpfiles1="$tmppath/_${inname%.*}_pc"
    cdo eofcoeff "$1" "$infile" "$tmpfiles1"

    # set height to PC number before merging
    for tmpfile1 in "$tmpfiles1"*; do
        tmpname2=$(basename "$tmpfile1")
        tmpname2=${tmpname2:1}
        # extract pc number from filename
        num=${tmpname2#*_pc}
        num=${num%.*}
        cdo --silent setlevel,"$num" -setzaxis,"$zaxis" "$tmpfile1" "$tmppath/$tmpname2"
    done

    # merge PCs in a single file
    tmpfiles2="$tmppath/${inname%.*}_pc"
    outfile="$outpath/pcs_$inname"
    cdo -f nc4 -z zip -O --reduce_dim merge "$tmpfiles2"* "$outfile"

    echo -e "${color}PCs written to '${outfile}'${reset}"
    n=$((n + 1))
done

# remove temporary files
rm -rf "$tmppath"
