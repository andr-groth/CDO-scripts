#!/bin/bash
# =============================================================================
# Create anomalies for multiple files.
#
# The script reads the parameters from the file CONFIGFILE and creates the
# anomalies for all files in INFILES.
#
# The anomalies are saved in the folder(s) of the INFILES in a subfolder
# named `anom` and with `anom_` prepended to the name of INFILES.
#
# The corresponding climatological mean fields are saved in the folder(s) of
# the INFILES in a subfolder named `anom/mean` and with `mean_` prepended to
# the name of INFILES.
#
# Usage:
#    ./get_anom.sh CONFIGFILE INFILES
#
# The CONFIGFILE is a shell script that will be executed to define parameters.
# The following parameters will be used by this script:
#
#   date = startdate,enddate used in `cdo seldate`
#   grid = grid name in `cdo remapcon`
#   landmask = true/false restricts grid points to land
#   logscale = true/false converts variables to log scale
#   lonlatbox = longitude,latitude limits used in `cdo sellonlatbox`
#   min = minimum value used for log scale
#   names = variable name(s) used in `cdo selname`
#   regions = filename defining a region used in `cdo maskregion`
#   refdate = startdate,enddate for climatological mean used in `cdo seldate`
#
# Author: Andreas Groth
# =============================================================================

# set example parameters for CMIP6 historical tos
date="1850-01-01,2014-12-31"
grid="global_1"
landmask=false
logscale=false
lonlatbox="-180,180,-90,90"
min=
names="sst"
regions=
refdate="1900-01-01,1999-12-31"

# overwrite parameters with CONFIGFILE file
# shellcheck source=/dev/null
source "$1"

# CDO global parameters
export REMAP_EXTRAPOLATE=off

params="date=${date}\ngrid=${grid}\nlandmask=${landmask}\nlogscale=${logscale}\nlonlatbox=${lonlatbox}\nmin=${min}\nnames=${names}\nregions=${regions}\nrefdate=${refdate}"

# path of temporay files
tmppath="./_tmp/get_anom_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$tmppath"

# colors
color='\033[0;33m' # yellow
reset='\033[0m'    # color reset

echo "================================================================================"
echo "Create anomalies for $(($# - 1)) file(s)"
echo -e "  ${params//'\n'/'\n  '}"

n=1
N=$(($# - 1))
for infile in "${@:2}"; do
	echo "--------------------------------------------------------------------------------"
	echo -e "${color}$n/$N    Process '${infile}'${reset}"

	inpath=$(dirname "$infile")
	inname=$(basename "$infile")

	# extract field and time period
	tmpfile1="$tmppath/tmp1_$inname"
	cdo -f nc4 -w -r -seldate,$date -setcalendar,standard -setreftime,1850-01-01,12:00:00,days -selname,"$names" "$infile" "$tmpfile1"

	# (optional) convert to log-scale
	if [ $logscale = true ]; then
		tmpfile2="$tmppath/tmp2_$inname"
		# clip small values before log
		cdo -f nc4 -log -setrtoc,-inf,"$min","$min" "$tmpfile1" "$tmpfile2"
	else
		tmpfile2="$tmpfile1"
	fi

	# select box and grid resolution
	tmpfile3="$tmppath/tmp3_$inname"
	cdo -f nc4 --reduce_dim -sellonlatbox,$lonlatbox -remapdis,$grid "$tmpfile2" "$tmpfile3"

	# (optional) restrict to regions (polygons)
	if [ -n "$regions" ]; then
		tmpfile4="$tmppath/tmp4_$inname"
		cdo -f nc4 -maskregion,"$regions" "$tmpfile3" "$tmpfile4"
	else
		tmpfile4="$tmpfile3"
	fi

	# (optional) restrict to land (topo>0)
	if [ $landmask = true ]; then
		tmpfile5="$tmppath/tmp5_$inname"
		# set grid points with topo<=0 to missing
		cdo -f nc4 -mul "$tmpfile4" -setctomiss,0 -gtc,0 -remapbil,"$tmpfile4" -topo "$tmpfile5"
	else
		tmpfile5="$tmpfile4"
	fi

	# get anomalies wrt to reference period
	outpath1="$inpath/anom"
	outpath2="$inpath/anom/mean"
	mkdir -p "$outpath2"

	outfile1="$outpath1/anom_$inname"
	outfile2="$outpath2/mean_$inname"

	cdo -f nc4 -z zip ymonmean -seldate,$refdate "$tmpfile5" "$outfile2"
	cdo -f nc4 -z zip ymonsub "$tmpfile5" "$outfile2" "$outfile1"

	# export config
	echo -e $params >"$outpath1/anom.cfg"

	echo -e "${color}Anomalies written to '$outfile1.${reset}"
	echo -e "${color}Mean      written to '$outfile2'.${reset}"
	n=$((n + 1))
done

# remove temporary files
rm -rf "$tmppath"
