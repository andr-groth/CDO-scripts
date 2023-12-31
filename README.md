# CDO scripts

Collection of scripts offering a convenient way to process multiple netCDF files with the [Climate Data
Operators (CDO)](https://code.mpimet.mpg.de/projects/cdo) tool.

## Requirements

[Climate Data Operators (CDO)](https://code.mpimet.mpg.de/projects/cdo) tool is required, which can be installed with:

```bash
sudo apt install cdo
```

Scripts tested with CDO version 2.0.4-1 on Ubuntu 22.04.

## Documentation

See the [documentation](https://andr-groth.github.io/CDO-scripts/) for more details on the available scripts.

### Main scripts

The main scripts are:

- The `get_anom.sh` script is used to obtain anomalies for multiple netCDF files.

- The `get_eofs.sh` script is used to obtain ensemble Empirical Orthogonal Functions (EOFs) from multiple netCDF files.

- The `get_pcs.sh` script is used to calculate Principal Components (PCs) for multiple netCDF files.

### Script combinations

Further scripts provide a combination of the main scripts:

- The `prepare_data.sh` script performs three main steps: creating anomalies, calculating ensemble EOFs, and obtaining individual PCs.

- The `prepare_data2.sh` script performs two main steps: creating anomalies and obtaining individual PCs. In contrast to the script `prepare_data.sh`, the EOFs are not calculated from the netCDF files in the given folder, but provided as an additional argument to the script.

### Additional scripts

Additional scripts are:

- The `merge.sh` script is used to merge netCDF files in time with the same filename prefix in a specified directory.
