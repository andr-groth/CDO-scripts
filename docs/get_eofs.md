# Get EOFs

The `get_eofs.sh` script is used to obtain ensemble Empirical Orthogonal Functions (EOFs) from multiple netCDF files. The script concatenates the input files in time and calculates a single set of EOFs and eigenvalues. The number of EOFs to calculate is specified as the first argument to the script.

## Usage

```
./get_eofs.sh NEOFS INFILES
```

Arguments:

- `NEOFS`: The number of EOFs to calculate.
- `INFILES`: One or more input netCDF files from which to calculate the EOFs.

## Output

The script saves the following output files in a subfolder named `pcs`, created in the folder of the first input file:

- `eigenvalues.csv`: A CSV file containing the eigenvalues of the EOFs.
- `eofs.nc`: A netCDF file containing the ensemble EOFs.
