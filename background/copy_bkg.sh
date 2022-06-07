#!/usr/bin/env bash

# Forecast start time: 20201214_15
yy_rst=2020
mm_rst=12
dd_rst=15
hh_rst=03

# Next calendar day
yy_nxt=2020
mm_nxt=12
dd_nxt=15

# Path of background files from GEOS experiemnt
geos_path=/discover/nobackup/projects/gmao/dadev/rtodling/archive/x0044/rs

# Path in R2D2
r2d2_path=$NOBACKUP/JediEwok/R2D2DataStore/Shared/geos/fc/x0044/c360

# Untar the background files
tar -xvf ${geos_path}/Y${yy_rst}/M${mm_rst}/x0044.trajrst.${yy_rst}${mm_rst}${dd_rst}_${hh_rst}z.tar

# Move files (should be in a loop)
# --------------------------------
# The file 20201214_2100z is 06H ahead of 20201214_1500z
# The file 20201214_2200z is 07H ahead of 20201214_1500z
# etc...

mkdir -p $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}

# 15z
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_2100z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT6H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_2200z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT7H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_2300z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT8H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_nxt}${mm_nxt}${dd_nxt}_0000z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT9H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_nxt}${mm_nxt}${dd_nxt}_0100z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT10H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_nxt}${mm_nxt}${dd_nxt}_0200z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT11H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_nxt}${mm_nxt}${dd_nxt}_0300z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT12H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc

# 21z
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0300z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT6H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0400z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT7H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0500z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT8H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0600z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT9H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0700z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT10H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0800z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT11H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0900z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT12H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc

# 03z
mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_0900z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT6H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1000z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT7H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1100z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT8H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1200z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT9H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1300z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT10H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1400z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT11H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1500z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT12H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc

# 09z
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1500z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT6H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1600z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT7H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1700z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT8H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1800z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT9H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_1900z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT10H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_2000z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT11H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
#mv x0044.traj_lcv_rst.${yy_rst}${mm_rst}${dd_rst}_2100z.nc4 $r2d2_path/${yy_rst}-${mm_rst}-${dd_rst}/geos.x0044.fc.PT12H.${yy_rst}-${mm_rst}-${dd_rst}T${hh_rst}:00:00Z.bkg.nc
