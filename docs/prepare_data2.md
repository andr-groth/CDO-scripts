# Prepare data2

The `prepare_data2.sh` script is used to process netCDF files in a given folder. It performs two main steps: creating
anomalies and obtaining individual PCs (Principal Components).

!!! note
    In contrast to the [`prepare_data.sh`](prepare_data.md), the EOFs are not calculated from the anomalies, but provided as an additional argument `EOFFILES` to the script.

## Usage

To use the script, run the following command in the terminal:

```bash
./prepare_data2.sh CONFIGFILE EOFFILE FILEPATH
```

### Arguments

- `CONFIGFILE`: The configuration file that provides parameters for creating anomalies.
- `EOFFILE`: The file containing the EOFs.
- `FILEPATH`: The path to the folder containing the netCDF files to be processed.  The script will process all `*.nc`
  files in the folder.

### Workflow

1. **Create Anomalies**
    - The script calls the [`get_anom.sh`](get_anom.md) script to create anomalies for each input netCDF file.
    - Anomalies are created for each input file using the specified parameters from the configuration file.

2. **Make a copy of EOFs**
    - The provided EOFs file (`EOFFILE`) is copied to a subfolder named `prj/` within `FILEPATH`. The `prj/` subfolder is created if it doesn't already exist.

3. **Obtain Individual PCs**
    - The script calls the [`get_pcs.sh`](get_pcs.md) script to obtain individual PCs by projecting the anomalies from the first step onto the copied EOFs.

### Output

The resulting data files are saved in the following subfolders:

- __Anomalies__: The resulting anomalies are saved in a subfolder named `anom/` within `FILEPATH`.
- __Copied EOFs__: The copied EOFs are saved in a subfolder named `anom/prj/` within `FILEPATH`.
- __PCs__: The individual PCs are saved in a subfolder named `anom/prj/` within `FILEPATH`.

## Example

Suppose we want to process netCDF files located in the folder `data2/files/`. We have a configuration file named `config.sh`, and we have EOFs stored in the file `data/eofs.nc`.

The command to run the script would be:

```shell
./prepare_data2.sh config.sh data/eofs.nc data2/files/
```

The resulting data files are:

- __Anomalies__: `data2/files/anom/anom_*.nc`.
- __Copied EOFs__: `data2/files/anom/prj/eofs.nc`.
- __PCs__: `data2/files/anom/prj/pcs_*.nc`.