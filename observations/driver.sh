#!/usr/bin/env bash

# Modules for ioda-converters
# ---------------------------
module purge

export OPT=/discover/swdev/jcsda/modules
module use $OPT/modulefiles/apps
module use $OPT/modulefiles/core
module load jedi/intel-impi
module list

jedibuild=/discover/nobackup/drholdaw/JediSwell/bundle/1.0.5/build-intel-impi-release

# Ioda Python
export LD_LIBRARY_PATH=$jedibuild/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$jedibuild/lib/python3.8:$PYTHONPATH
export PYTHONPATH=$jedibuild/lib/python3.8/pyioda:$PYTHONPATH


# Turn on/off oops trace
# ----------------------
export OOPS_TRACE=0


# Times needed by script
# ----------------------

# Analysis datetime
yyyy=2020
mm=12
dd=15
hh=00

# Begining of the window datetime -3h
ryyyy=2020
rmm=12
rdd=14
rhh=21

# Previous analysis restart datetime -9h
pyyyy=2020
pmm=12
pdd=14
phh=15

# Geos experiment name and paths
# ------------------------------
exp_id=x0044
exp_id_length_plus_one=6
exp_dir=x0044.jj_20220520
exp_path=/archive/u/jjin3/
exp_id_r2d2=x0044_jjin_20220520

#exp_id=x0044
#exp_id_length_plus_one=6
#exp_dir=x0044
#exp_path=/discover/nobackup/projects/gmao/dadev/rtodling/archive/
#exp_id_r2d2=x0044

#exp_id=x0044
#exp_id_length_plus_one=6
#exp_dir=x0044
#exp_path=/discover/nobackup/bkarpowi/archive/
#exp_id_r2d2=x0044_jjin_20220520

ges_or_anl=ges

# Instruments to get
# ------------------
instruments=*
get_geovals=0

# Full path to ncdiag files
# -------------------------
indir=${exp_path}/${exp_dir}/obs/Y${yyyy}/M${mm}/D${dd}/H${hh}/


# R2D2 output directory
# ---------------------
r2d2dir=/discover/nobackup/drholdaw/JediData/GMAOReferenceRun/R2D2DataStore/Shared


# Observation output directory
# ----------------------------
outdir=$r2d2dir/ncdiag/ob/${exp_id_r2d2}/PT6H/${ryyyy}-${rmm}-${rdd}


# GeoVaLs output directory
# ------------------------
geodir=$r2d2dir/ncdiag/ob/${exp_id_r2d2}_geovals/PT6H/${ryyyy}-${rmm}-${rdd}


# Observations to skip
# --------------------
declare -a skips=("mls55_aura" "omi_aura" "ompsnm_npp") # Skips for ozone
#declare -a skips=("none") # No Skips

# Make a temporary directory and link renamed inputs
# --------------------------------------------------
rm -rf tmp
mkdir -p tmp/
pathfiles=`ls $indir/*${instruments}*${ges_or_anl}*nc4`
for pathfile in ${pathfiles}; do
  filename=$(basename "${pathfile}")
  # Skip list
  skip_instr=0
  for skip in ${skips[@]}; do
    if [[ "$filename" == *"$skip"* ]]; then
      echo "Skipping " $skip
      skip_instr=1
    fi
  done
  if [[ $skip_instr == 0 ]]; then
    ln -sf $pathfile tmp/${filename:${exp_id_length_plus_one}:10000}
  fi
done

# Convert all obs to ioda format
# ------------------------------
if [[ $get_geovals == 0 ]]
then
  mkdir -p $outdir
  python $jedibuild/bin/proc_gsi_ncdiag.py -o $outdir tmp/
  proc_pass_fail=$?
else
  mkdir -p $outdir $geodir
  python $jedibuild/bin/proc_gsi_ncdiag.py -o $outdir -g $geodir tmp/
  proc_pass_fail=$?
fi


# Check for success
# -----------------
if [ $proc_pass_fail -eq 0 ]; then
  rm -rf tmp
else
  echo "ABORT: Processing step failed"
  exit 1
fi


# Combine conventional obs
# ------------------------
declare -a conv_types=("aircraft_" "rass_" "sfc_" "sfcship_" "sondes_")

# Iterate the string array using for loop
for conv_type in ${conv_types[@]}; do
  files=`ls $outdir/$conv_type* 2> /dev/null`
  if [ -n "$files" ]; then
    $jedibuild/bin/combine_obsspace.py -i $files -o $outdir/${conv_type}obs_${yyyy}${mm}${dd}${hh}.nc4
    if [ $? -eq 0 ]; then
      rm $files
    else
      echo "Combine conventional for " $conv_type " failed"
      exit 1
    fi
  fi
done


## Convert GNSSRO from BUFR
## ------------------------
#inputbufr=/archive/input/dao_ops/obs/flk/ncep_g5obs/bufr/GPSRO/Y${yyyy}/M${mm}/gdas1.${yyyy:2:4}${mm}${dd}.t${hh}z.gpsro.tm00.bufr_d
#rm -f $outdir/gps_bend_obs_*.nc4
#$jedibuild/bin/gnssro_bufr2ioda ${yyyy}${mm}${dd}${hh} ${inputbufr} $outdir/gnssrobndnbam_obs_${yyyy}${mm}${dd}${hh}.nc4


# Rename the files with R2D2 standard
# -----------------------------------
rename _obs_${yyyy}${mm}${dd}${hh}.nc4 .${ryyyy}-${rmm}-${rdd}T${rhh}:00:00Z.nc4 ${outdir}/*

pathfiles=`ls $outdir/*`
for pathfile in ${pathfiles}; do
  filename=$(basename "${pathfile}")
  mv $pathfile $outdir/ncdiag.${exp_id_r2d2}.ob.PT6H.$filename
done

if [[ $get_geovals == 1 ]]; then
  rename _geoval_${yyyy}${mm}${dd}${hh}.nc4 .${ryyyy}-${rmm}-${rdd}T${rhh}:00:00Z.nc4 ${geodir}/*
  pathfiles=`ls $geodir/*`
  for pathfile in ${pathfiles}; do
    filename=$(basename "${pathfile}")
    mv $pathfile $geodir/ncdiag.${exp_id_r2d2}_geovals.ob.PT6H.$filename
  done
fi

# Convert GSI bias correction
# ---------------------------
outdirbias=$r2d2dir/gsi/bc/${exp_id_r2d2}/${pyyyy}-${pmm}-${pdd}
rm -rf $outdirbias
mkdir -p $outdirbias

rm -rf satbias
cp -r satbias_in satbias
cd satbias

restart_tar_file=$exp_path/$exp_dir/rs/Y${ryyyy}/M${rmm}/${exp_id}.rst.${ryyyy}${rmm}${rdd}_${rhh}z.tar

if [ -f ${restart_tar_file} ]; then

  tar -xvf ${restart_tar_file} ${exp_id}.ana_satbias_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt ${exp_id}.ana_satbiaspc_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt

  ln -sf ${exp_id}.ana_satbias_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt ana_satbias_rst.txt
  ln -sf ${exp_id}.ana_satbiaspc_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt ana_satbiaspc_rst.txt

  declare -a sensors=("airs_aqua" "amsr2_gcom-w1" "amsua_aqua" "amsua_metop-a" "amsua_metop-b" "amsua_metop-c"
                      "amsua_n15" "amsua_n18" "amsua_n19" "atms_n20" "atms_npp" "avhrr3_metop-a"
                      "avhrr3_metop-b" "avhrr3_n18" "avhrr3_n19" "cris-fsr_npp" "cris-fsr_n20"
                      "gmi_gpm" "hirs4_metop-a" "hirs4_n18" "hirs4_n19" "iasi_metop-a" "iasi_metop-b"
                      "mhs_metop-a" "mhs_metop-b" "mhs_metop-c" "mhs_n19" "seviri_m08" "ssmis_f17"
                      "ssmis_f18" )

  # Tlapse
  for sensor in ${sensors[@]}; do
    echo $sensor
    grep -i $sensor ana_satbias_rst.txt | awk '{print $2" "$3" "$4}' > ${outdirbias}/gsi.${exp_id_r2d2}.bc.${sensor}.${pyyyy}-${pmm}-${pdd}T${phh}:00:00Z.tlapse
  done

  $jedibuild/bin/satbias2ioda.x satbias_converter.yaml

  rename satbias_ gsi.${exp_id_r2d2}.bc. *nc4
  rename .nc4 .${pyyyy}-${pmm}-${pdd}T${phh}:00:00Z.satbias *nc4
  mv *satbias ${outdirbias}/

  cd ../
  rm -rf satbias

fi
