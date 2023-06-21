# Merge netCDF files

The `merge.sh` script is used to merge netCDF files in time with the same filename prefix in a specified directory.

## Usage

```shell
./merge.sh [path]
```

Arguments:

- `path`:  optional argument specifiyng the directory containing the NetCDF files to be merged. If no path is provided, the current directory `.` will be used as the default.

## Script Workflow

The script executes the following steps:

1. Sets up the output directory for the merged files. The directory is named `merged` and is created within the specified `path` or default `.` input directory.
2. Identifies groups of files based on a substring (prefix) extracted before the last underscore in each file's name.
4. Merges the files with the same prefix.
    - If the output file already exists, the script skips merging and displays information about the existing file.
    - If the output file doesn't exist, the script performs the merging operation using CDO's `mergetime` functionality. The merged file is saved in the output directory with the same prefix.

## Example

Suppose we have four files `file_1_a.nc`, `file_1_b.nc` `file_2_a.nc`, and `file_2_b.nc` in the directory
`/path/to/files`. To merge the files with the same prefix, we would run the following command:

```shell
./merge.sh /path/to/files
```

The script will merge:

- `file_1_a.nc` and `file_1_b.nc` in `file_1.nc`
- `file_2_a.nc` and `file_2_b.nc` in `file_2.nc`

The merged files will be saved in `/path/to/files/merged`.
