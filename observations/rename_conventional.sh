#!/usr/bin/env bash

# radiosonde -> sondes
# --------------------
filepaths=`find /discover/nobackup/drholdaw/JediEwok/R2D2DataStore/Shared/ncdiag/ob/x0044/ -name '*.radiosonde.*' -print`

for filepath in $filepaths
do
    rename .radiosonde. .sondes. $filepath
done


# ship -> sfcship
# ---------------
filepaths=`find /discover/nobackup/drholdaw/JediEwok/R2D2DataStore/Shared/ncdiag/ob/x0044/ -name '*.ship.*' -print`

for filepath in $filepaths
do
    rename .ship. .sfcship. $filepath
done



# rass -> rass_tv
# ---------------
filepaths=`find /discover/nobackup/drholdaw/JediEwok/R2D2DataStore/Shared/ncdiag/ob/x0044/ -name '*.rass.*' -print`

for filepath in $filepaths
do
    rename .rass. .rass_tv. $filepath
done
