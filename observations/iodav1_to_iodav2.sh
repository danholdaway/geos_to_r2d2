#!/usr/bin/env bash

# Slurm
# -----
#SBATCH --account=g0613
#SBATCH --qos=advda
#SBATCH --job-name=iodav1_to_iodav2
#SBATCH --output=iodav1_to_iodav2.o%j
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=12:00:00

# Modules for ioda-converters
# ---------------------------
module purge
module load jedi/gnu-impi
module unload jedi-python/3.8.3
module load miniconda
module list

export OOPS_TRACE=1

# Path to ioda-converters install
# -------------------------------
iodabin=/discover/nobackup/drholdaw/JediOpt/src/ioda-bundle/develop/build-gni-impi/bin

# List of all input files
# -----------------------
filepaths=`find /discover/nobackup/asewnath/JediEwok/R2D2DataStore/Shared/ncdiag/ob/x0044/ -name 'ncdiag*.nc4' -print`

# Temporary holder
# ----------------
mkdir -p tmp

for filepath in $filepaths
do

    # Split into path and filename
    path=$(dirname "${filepath}")
    file=$(basename "${filepath}")

    # Replace output path name
    pathout=${path/asewnath/drholdaw}

    # Create target directory
    mkdir -p $pathout

    # Convert if not done already
    if [ ! -f $pathout/$file ]; then
      $iodabin/ioda-upgrade.x $filepath tmp/$file
      mv tmp/$file $pathout/$file
    fi
done

# Remove temporary directory
rm -rf tmp
