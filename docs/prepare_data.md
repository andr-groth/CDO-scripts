# Prepare data

The `prepare_data.sh` script is used to process netCDF files in a given folder. It performs three main steps: creating
anomalies, calculating ensemble EOFs (Empirical Orthogonal Functions), and obtaining individual PCs (Principal
Components). The resulting anomalies, EOFS, and PCs are saved in specific subfolders within the input folder `FILEPATH`.

## Usage

To use the script, run the following command in the terminal:

```shell
./prepare_data.sh CONFIGFILE NEOFS FILEPATH
```

### Arguments

- `CONFIGFILE`: The configuration file that provides parameters for creating anomalies.
- `NEOFS`: The number of EOFs to calculate.
- `FILEPATH`: The path to the folder containing the netCDF files to be processed. The script will process all `*.nc`
  files in the folder.

### Workflow

1. **Create Anomalies**
    - The script calls the `get_anom.sh` script to create anomalies for each input netCDF file.
    - The configuration file (`CONFIGFILE`) and the path to the netCDF files (`FILEPATH`) are provided as arguments.
    - Anomalies are created for each input file matching `*.nc`, using the specified parameters from the configuration file.

2. **Calculate Ensemble EOFs**
    - The script calls the `get_eofs.sh` script to calculate ensemble EOFs and eigenvalues.
    - The number of EOFs to calculate is determined by the `NEOFS` argument.
    - The anomalies created in the previous step are used as input.

3. **Obtain Individual PCs**
    - The script calls the `get_pcs.sh` script to obtain individual PCs by projecting the anomalies onto the ensemble EOFs.

### Output
The resulting data files are saved in the following subfolders:

- __Anomalies__: The resulting anomalies are saved in a subfolder named `anom` within `FILEPATH`.
- __Ensemble EOFs__: The calculated EOFs are saved in a subfolder named `anom/pcs` within `FILEPATH`.
- __PCs__: The individual PCs are saved in a subfolder named `anom/pcs` within `FILEPATH`.

## Example

Suppose we want to process netCDF files located in the folder `data/files/`. We have a configuration file named `config.sh`, and we want to calculate 10 EOFs.

The command to run the script would be:

```shell
./prepare_data.sh config.sh 10 data/files/
```

The resulting data files are:

- __Anomalies__: `data/files/anom/anom_*.nc`.
- __Ensemble EOFs__: `data/files/anom/pcs/eofs.nc`.
- __PCs__: `data/files/anom/pcs/pcs_*.nc`.