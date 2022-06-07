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
inputs_path = '/discover/nobackup/drholdaw/JediData/GMAOReferenceRun/R2D2DataStore/Shared/ncdiag/ob/x0044_jjin_20220520_geovals/PT6H/2020-12-14'
output_path = '/discover/nobackup/drholdaw/R2D2DataStore/Shared/ncdiag/ob/x0044_jjin_20220520_geovals/PT6H/2020-12-14/'

# List of files to process
os.chdir(inputs_path)
files = glob.glob('*nc4')

# List of data variables that are metadata
metadata = ['latitude', 'longitude', 'time']

# Loop over files
for file in files:

    # Input/output pathfile
    input_pathfile = os.path.join(inputs_path, file)
    output_pathfile = os.path.join(output_path, file)

    # Print info
    print('Processing: ', file, ' to ', output_pathfile)

    # Open input file
    ncstart = nc.Dataset(input_pathfile)

    # Create output file
    ncfinal = nc.Dataset(output_pathfile, mode='w')

    # Create dimensions
    dim_val = ncfinal.createDimension('nlocs', ncstart.dimensions['nlocs'].size)
    for variable in list(ncstart.variables):
        if variable not in metadata:
            if len(ncstart.variables[variable].shape) == 1:
                dim_size = 1
            elif len(ncstart.variables[variable].shape) == 2:
                dim_size = ncstart.variables[variable].shape[1]
            else:
                print("Abort: Size of array not known in setting dimensions")
            dim_val = ncfinal.createDimension(variable + '_nval', dim_size)

    # Write variables for each dimension
    for dimension in list(ncfinal.dimensions):
        cor_val = ncfinal.createVariable(dimension, 'int32', dimension)
        cor_val[:] = range(1, ncfinal.dimensions[dimension].size+1)

    # Write the variables
    for variable in list(ncstart.variables):
        if variable in metadata:
            cor_val = ncfinal.createVariable('MetaData/'+variable, ncstart.variables[variable].dtype, ncstart.variables[variable].dimensions)
            cor_val[:] = ncstart.variables[variable][:]
        else:
            dim_array = ['nlocs', variable + '_nval']
            cor_val = ncfinal.createVariable('GeoVaLs/'+variable, ncstart.variables[variable].dtype, dim_array)
            if len(ncstart.variables[variable].shape) == 1:
                cor_val[:,:] = ncstart.variables[variable][:]
            else:
                cor_val[:,:] = ncstart.variables[variable][:,:]

    ncstart.close()
    ncfinal.close()
