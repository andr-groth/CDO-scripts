#!/bin/bash
# ================================================================================
# Create anomalies and obtain PCs for all netCDF files in a given folder.
#
# The example script processes all `*.nc` files in the given FILEPATH. The different
# steps of the script are:
#
# 1. Create anomalies for each input file using `get_anom.sh`. The paramaters are
#   provided in a file provided by the argument CONFIGFILE.
#
# 2. Make a copy of the EOFs provided as the argument EOFFILE.
#
# 3. Obtain individual PCs by projecting the anomalies onto the EOFs provided by
#    the argument EOFFILE.
#
# The resulting anomalies are saved in a subfolder of FILEPATH named `anom`.
# A copy of EOFFILE and the resulting PCs are saved in a subfolder of FILEPATH
#  named`anom/prj`.
#
# Usage:
#   ./prepare_data2.sh CONFIGFILE EOFFILE FILEPATH
#
# Author: Andreas Groth
# ================================================================================

CONFIGFILE="$1"
EOFFILE="$2"
FILEPATH="$3"

echo "Processing files in '$FILEPATH' ..."

# 1. get anomalies
./get_anom.sh "$CONFIGFILE" "$FILEPATH"/*.nc

# 2. Make copy of EOFFILE
echo "================================================================================"
echo "Copy EOFs"
outpath="$FILEPATH/anom/prj"
mkdir -p "$outpath"
cp -v "$EOFFILE" "$outpath"
echo "--------------------------------------------------------------------------------"

# 3. get PCs
eof_name=$(basename "$EOFFILE")
./get_pcs.sh "$outpath/$eof_name" "$FILEPATH"/anom/anom_*.nc
