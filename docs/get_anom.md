# Get anomalies

The `get_anom.sh` script is used to obtain anomalies for multiple files. It reads parameters from a configuration file and applies them to the input files to generate anomalies. The anomalies are saved in a subfolder named `anom` within the input file's folder, with `anom_` prepended to the input file's name. Additionally, the corresponding climatological mean fields are saved in a subfolder named `anom/mean`, with `mean_` prepended to the input file's name.

## Usage

```
./get_anom.sh CONFIGFILE INFILES
```

Arguments:

- `CONFIGFILE`: Shell script that defines the parameters.
- `INFILES`: One or more input netCDF files for which anomalies will be obtained.

## Configuration file

The `CONFIGFILE` provides the parameters required for anomaly creation. The following parameters are used by the script:

- __`date`__: The start and end dates for the anomalies in the format `startdate,enddate`. Used in the `cdo seldate` command.
- __`grid`__: The grid name used in the `cdo remapcon` command.
- __`landmask`__: A boolean parameter (`true` or `false`) that restricts grid points to land.
- __`logscale`__: A boolean parameter (`true` or `false`) that converts variables to log scale.
- __`lonlatbox`__: Longitude and latitude limits used in the `cdo sellonlatbox` command in the format `longitude_min,longitude_max,latitude_min,latitude_max`.
- __`min`__: The minimum value used for log scale conversion.
- __`names`__: Variable name(s) used in the `cdo selname` command.
- __`regions`__: The filename defining a region used in the `cdo maskregion` command.

- __`refdate`__: The start and end dates for the climatological mean used in the `cdo seldate` command.

!!! note
    - Examples of `CONFIGFILE` file can be found in the `/configs` folder of this repository.
    - Examples of `regions` files can be found in the `/regions` folder of this respository.


## Output

- The anomalies are saved in a subfolder named `anom` within the input file's folder, with `anom_` prepended to the
  input file's name.
- The corresponding climatological mean fields are saved in a subfolder named `anom/mean`, with `mean_` prepended to the input file's name.


## Example

Here's an example to illustrate the usage of the `get_anom.sh` script:

Suppose we have the following configuration file named `config.sh`:

```bash
date="1850-01-01,2014-12-31"
grid="global_1"
landmask=false
logscale=false
lonlatbox="-180,180,-90,90"
min=
names="sst"
regions=
refdate="1900-01-01,1999-12-31"
```

And we want to create anomalies for all netCDF files in `path/to/files/*.nc`.

To execute the script with the given configuration file and input files, we run the following command:

```bash
./get_anom.sh config.sh path/to/files/*.nc
```

The script reads the parameters from `config.sh` and process the input files accordingly. Anomalies will be saved in the `path/to/files/anom` subfolder, with `anom_` prepended to the original file names. The corresponding climatological mean fields will be saved in the `path/to/files/anom/mean` subfolder, with `mean_` prepended to the original file names.