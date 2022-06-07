# (C) Copyright 2021-2022 United States Government as represented by the Administrator of the
# National Aeronautics and Space Administration. All Rights Reserved.

# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.

# --------------------------------------------------------------------------------------------------

import glob
import netCDF4 as nc
import os

# --------------------------------------------------------------------------------------------------

# Paths
inputs_path = 'geovals'
output_path = 'obs'

# List of files to process
input_pathfiles = glob.glob(os.path.join(inputs_path,'*nc4'))
input_pathfiles = sorted(input_pathfiles)

# List of data variables that are metadata
metadata = ['latitude', 'longitude', 'time']

# Loop over files
for input_pathfile in input_pathfiles:

    # Output filename
    input_file = os.path.basename(input_pathfile)
    output_file = input_file.replace('_geoval_', '_obs_')

    # Output pathfile
    output_pathfile = os.path.join(output_path, output_file)

    # Print info
    print('Merging: ', input_pathfile, ' into ', output_pathfile)

    # Check output file exists
    if not os.path.exists(output_pathfile):
        print('          WARNING: Skipping this GeoVaLs file as no obs file found')
        continue

    # Open input file
    ncstart = nc.Dataset(input_pathfile)

    # Create output file
    ncfinal = nc.Dataset(output_pathfile, mode='a')

    # Create dimensions
    for variable in list(ncstart.variables):
        if variable not in metadata:

            # Add a dimension for the vertical coordinate for each GeoVaL
            if len(ncstart.variables[variable].shape) == 1:
                dim_size = 1
            elif len(ncstart.variables[variable].shape) == 2:
                dim_size = ncstart.variables[variable].shape[1]
            else:
                print("Abort: Size of array not known in setting dimensions")

            # Dimension name
            dim_name = variable + '_nval'
            dim_val = ncfinal.createDimension(dim_name, dim_size)

            # Write variables for each dimension
            cor_val = ncfinal.createVariable(dim_name, 'int32', dim_name)
            cor_val[:] = range(1, ncfinal.dimensions[dim_name].size+1)

            # Write the variables
            dim_array = ['nlocs', variable + '_nval']
            cor_val = ncfinal.createVariable('GsiGeoVaLs/'+variable,
                                             ncstart.variables[variable].dtype, dim_array)
            if len(ncstart.variables[variable].shape) == 1:
                cor_val[:,:] = ncstart.variables[variable][:]
            else:
                cor_val[:,:] = ncstart.variables[variable][:,:]

    ncstart.close()
    ncfinal.close()
