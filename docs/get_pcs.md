# Get PCs

The `get_pcs.sh` script is used to calculate Principal Components (PCs) for multiple netCDF files projected onto a given set of Empirical Orthogonal Functions (EOFs).

## Usage

```
./get_pcs.sh EOFFILE INFILES
```

Arguments:

- `EOFFILE`: The netCDF file with the EOFs.
- `INFILES`: The netCDF files that are projected onto the EOFs to obtain the PCs.

## Output

The PCs are saved in the folder of the EOF file, with `pcs_` prepended to the filename.

## Example

Suppose we have the following files in the current directory:

- `eof.nc`: NetCDF file containing the EOFs.
- `data1.nc`: NetCDF file to be projected onto the EOFs.
- `data2.nc`: Another NetCDF file to be projected onto the EOFs.

To calculate the PCs for `data1.nc` and `data2.nc` using the EOFs in `eof.nc`, we would run the following command:

```
./get_pcs.sh eof.nc data1.nc data2.nc
```

The script would generate PC files for each input file, named `pcs_data1.nc` and `pcs_data2.nc`, respectively, and save them in the same directory as `eof.nc`.