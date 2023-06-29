## Overview

The collection of scripts offers a convenient way to process multiple netCDF files with the [Climate Data
Operators (CDO)](https://code.mpimet.mpg.de/projects/cdo) tool.

## Requirements

[Climate Data Operators (CDO)](https://code.mpimet.mpg.de/projects/cdo) tool is required, which can be installed with:

```bash
sudo apt install cdo
```

Scripts tested with CDO version 2.0.4-1 on Ubuntu 22.04.

## Main scripts

The main scripts are:

- The [`get_anom.sh`](get_anom.md) script is used to obtain anomalies for multiple netCDF files.

- The [`get_eofs.sh`](get_eofs.md) script is used to obtain ensemble Empirical Orthogonal Functions (EOFs) from multiple netCDF files.

- The [`get_pcs.sh`](get_pcs.md) script is used to calculate Principal Components (PCs) for multiple netCDF files.

## Script combinations

Further scripts provide a combination of the main scripts:

- The [`prepare_data.sh`](prepare_data.md) script performs three main steps: creating anomalies, calculating ensemble EOFs, and obtaining individual PCs.

- The [`prepare_data2.sh`](prepare_data2.md) script performs two main steps: creating anomalies and obtaining individual PCs. In contrast to the script `prepare_data.sh`, the EOFs are not calculated from the netCDF files in the given folder, but provided as an additional argument to the script.

## Additional scripts

Additional scripts are:

- The [`merge.sh`](merge.md) script is used to merge netCDF files in time with the same filename prefix in a specified directory.
