#!/bin/bash
# ================================================================================
# Create anomalies, EOFs, and PCs for all netCDF files in a given folder.
#
# The example script processes all `*.nc` files in the given FILEPATH. The different
# steps of the script are:
#
# 1. Create anomalies for each input file using `get_anom.sh`. The paramaters are
#   provided in a file provided by the argument CONFIGFILE.
#
# 2. Calculate ensemble EOFs and eigenvalues using `get_eofs.sh`. The number of
#    EOFs is defined by the argument NEOFS.
#
# 3. Obtain individual PCs by projecting the anomalies onto the EOFs using
#    `get_pcs.sh`.
#
# The resulting anomalies are saved in a subfolder of FILEPATH named `anom`.
# The resulting EOFS and PCs are saved in a subfolder of FILEPATH named `anom/pcs`.
#
# Usage:
#   ./prepare_data.sh CONFIGFILE NEOFS FILEPATH
#
# Author: Andreas Groth
# ================================================================================

CONFIGFILE="$1"
NEOFS="$2"
FILEPATH="$3"

echo "Processing files in '$FILEPATH' ..."

# 1. get anomalies
./get_anom.sh "$CONFIGFILE" "$FILEPATH"/*.nc

# 2. get EOFs
./get_eofs.sh "$NEOFS" "$FILEPATH"/anom/anom_*.nc

# 3. get PCs
./get_pcs.sh "$FILEPATH"/anom/pcs/eofs.nc "$FILEPATH"/anom/anom_*.nc
