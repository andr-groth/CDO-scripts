#!/bin/bash
# =============================================================================
# Get ensemble EOFs from multiple files
#
# The netCDF files are first concatentated in time and then a single set of EOFs
# and eigenvalues is obtained. The number of EOFS is specified as the first
# argument NEOFS to the script.
#
# The EOFs and eigenvalues are saved as `eofs.nc` and `eigenvalues.csv`,
# respectively, in a subfolder named `pcs`, which is created in the folder of the
# first input file in INFILES.
#
# Usage:
#    ./get_eofs.sh NEOFS INFILES
#
# Author: Andreas Groth
# ================================================================================

NEOFS=$1 # number of EOFs

# CDO global parameters
export CDO_WEIGHT_MODE=off            # eofspatial: use grid cell area for weighting
export CDO_SVD_MODE=danielson_lanczos # eofspatial: better for near-singular matrices (close to square)
export CDO_GRIDSEARCH_RADIUS=0.1      # remapnn: use nn search radius smaller than grid resolution
export REMAP_EXTRAPOLATE=off          # remapnn: extrapolation is off for nearest-neighbor remapping

# path of temporay files
tmppath="./_tmp/get_eofs_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$tmppath"

# path for results
outpath=$(dirname "$2")/pcs
mkdir -p "$outpath"

# save parameters
params="NEOFS=${NEOFS}\nCDO_WEIGHT_MODE=${CDO_WEIGHT_MODE}\nCDO_GRIDSEARCH_RADIUS=${CDO_GRIDSEARCH_RADIUS}"
echo -e "$params" >"$outpath/eofs.cfg"

color='\033[0;33m' # yellow
reset='\033[0m'    # color reset

N=$(($# - 1))
echo "================================================================================"
echo "Calculate $NEOFS ensemble EOFs from $N file(s)"
echo -e "  ${params//'\n'/'\n  '}"
echo "--------------------------------------------------------------------------------"
echo -e "${color}Concatenate $N file(s)${reset}"

tmpfile1=$"$tmppath/cat.nc"
tmpfile2=$"$tmppath/cat2.nc"
mskfile=$"$tmppath/mask.nc"

# concatenate all input files
cdo copy "${@:2}" "$tmpfile1"

# get spatial mask that excludes grid points with missing values
cdo ltc,1e20 -setmisstoc,1e20 -timavg "$tmpfile1" "$mskfile"

# convert to unstructured grid and scale by cosine of latitude
cdo mulcoslat -reducegrid,"$mskfile" "$tmpfile1" "$tmpfile2"

echo "--------------------------------------------------------------------------------"
echo -e "${color}Get $NEOFS EOFs${reset}"

# get EOFs from unstructured grid
_outfile1="$outpath/eigenvalues.nc"
outfile1="$outpath/eigenvalues.csv"
_outfile2="$tmppath/eofs.nc"
outfile2="$outpath/eofs.nc"
cdo -v eofspatial,"$NEOFS" "$tmpfile2" "$_outfile1" "$_outfile2"

# convert eigenvalues to text file
cdo -s output "$_outfile1" >"$outfile1"

# convert EOFs to regular grid
cdo -f nc4 -z zip remapnn,"$mskfile" "$_outfile2" "$outfile2"

# get spatial variance of (scaled) concatenated files on regular grid
_outfile3="$tmppath/data_var.nc"
outfile3="$outpath/data_var.nc"
cdo timvar "$tmpfile2" "$_outfile3"
cdo -f nc4 remapnn,"$mskfile" "$_outfile3" "$outfile3"

echo -e "${color}Output written to '${outfile1}' and '${outfile2}'${reset}"

# remove temporary files
rm -rf "$tmppath"

## end of script

# -----------------------------
# Collection of useful commands
# -----------------------------
#
## variance of scaled EOFs:
# cdo sqr -mul eofs.nc -remapnn,eofs.nc -sqrt eigenvalues.nc eofs_loadings.nc
#
## cumulative variance of scaled EOFs:
# cdo timcumsum -sqr -mul eofs.nc -remapnn,eofs.nc -sqrt eigenvalues.nc eofs_cum_loadings.nc
