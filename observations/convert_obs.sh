#!/usr/bin/env bash


# Modules for ioda-converters
# ---------------------------
module purge
module load jedi/gnu-impi
module unload jedi-python/3.8.3

export DHOPT=/discover/nobackup/drholdaw/opt/
module use -a $DHOPT/modulefiles/core
module load miniconda
module list

export OOPS_TRACE=1



# Path to ioda-converters install
# -------------------------------
iodabin=/discover/nobackup/drholdaw/JediOpt/src/ioda-bundle/develop/build-gni-impi/bin

# Analysis datetime
yyyy=2020
mm=12
dd=15
hh=18

# Begining of the window datetime -3h
ryyyy=2020
rmm=12
rdd=15
rhh=15

# Previous analysis restart datetime -9h
pyyyy=2020
pmm=12
pdd=15
phh=09

# Geos experiment name
exp=x0044j


# Input directory for data
# ------------------------
#expdir=/discover/nobackup/projects/gmao/dadev/rtodling/archive/$exp
expdir=/archive/u/jjin3/x0044j.crtm

indir=$expdir/obs/Y${yyyy}/M${mm}/D${dd}/H${hh}/


# R2D2 output directory
# ---------------------
r2d2dir=/discover/nobackup/drholdaw/JediData/GMAOReferenceRun/R2D2DataStore/Shared-jjin

outdir=$r2d2dir/ncdiag/ob/$exp/PT6H/${ryyyy}-${rmm}-${rdd}

# GeoVaLs output directory
# ------------------------
geodir=$r2d2dir/ncdiag/geovals/$exp/PT6H/${ryyyy}-${rmm}-${rdd}

# Make a temporary directory and link renamed inputs
# --------------------------------------------------
mkdir -p tmp/
pathfiles=`ls $indir/*gpm*ges*nc4`
for pathfile in ${pathfiles}; do
  filename=$(basename "${pathfile}")
  ln -sf $pathfile tmp/${filename:7:10000}
done

mkdir -p tmp/
pathfiles=`ls $indir/*gcom*ges*nc4`
for pathfile in ${pathfiles}; do
  filename=$(basename "${pathfile}")
  ln -sf $pathfile tmp/${filename:7:10000}
done


# Convert all obs to ioda format
# ------------------------------
mkdir -p $outdir #$geodir
python $iodabin/proc_gsi_ncdiag.py -n 1 -o $outdir tmp/
#python $iodabin/proc_gsi_ncdiag.py -n 1 -o $outdir -g $geodir tmp/
rm -rf tmp


## Combine conventional obs
## ------------------------
#declare -a conv_types=("aircraft_" "rass_" "sfc_" "sfcship_" "sondes_")
#
## Iterate the string array using for loop
#for conv_type in ${conv_types[@]}; do
#  files=`ls $outdir/$conv_type*`
#  $iodabin/combine_files.py -i $files -o $outdir/${conv_type}obs_${yyyy}${mm}${dd}${hh}.nc4
#  if [ $? -eq 0 ]; then
#    rm $files
#  else
#    echo Combine conventional for $conv_type failed
#    exit 1
#  fi
#done


## Convert GNSSRO from BUFR
## ------------------------
#inputbufr=/archive/input/dao_ops/obs/flk/ncep_g5obs/bufr/GPSRO/Y${yyyy}/M${mm}/gdas1.${yyyy:2:4}${mm}${dd}.t${hh}z.gpsro.tm00.bufr_d
#rm -f $outdir/gps_bend_obs_*.nc4
#$iodabin/gnssro_bufr2ioda ${yyyy}${mm}${dd}${hh} ${inputbufr} $outdir/gnssrobndnbam_obs_${yyyy}${mm}${dd}${hh}.nc4


# Rename the files with R2D2 standard
# -----------------------------------
rename _obs_${yyyy}${mm}${dd}${hh}.nc4 .${ryyyy}-${rmm}-${rdd}T${rhh}:00:00Z.nc4 ${outdir}/*

pathfiles=`ls $outdir/*`
for pathfile in ${pathfiles}; do
  filename=$(basename "${pathfile}")
  mv $pathfile $outdir/ncdiag.$exp.ob.PT6H.$filename
done


# Convert GSI bias correction
# ---------------------------
outdirbias=$r2d2dir/gsi/bc/${exp}/${pyyyy}-${pmm}-${pdd}
mkdir -p $outdirbias

cd satbias

tar -xvf $expdir/rs/Y${ryyyy}/M${rmm}/$exp.rst.${ryyyy}${rmm}${rdd}_${rhh}z.tar $exp.ana_satbias_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt $exp.ana_satbiaspc_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt

ln -sf $exp.ana_satbias_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt ana_satbias_rst.txt
ln -sf $exp.ana_satbiaspc_rst.${ryyyy}${rmm}${rdd}_${rhh}z.txt ana_satbiaspc_rst.txt


#declare -a sensors=("airs_aqua" "amsua_aqua" "amsua_metop-a" "amsua_metop-b" "amsua_metop-c"
#                    "amsua_n15" "amsua_n18" "amsua_n19" "atms_n20" "atms_npp" "amsr2_gcom-w1" "avhrr3_metop-a"
#                    "avhrr3_metop-b" "avhrr3_n18" "avhrr3_n19" "cris-fsr_npp" "cris-fsr_n20"
#                    "gmi_gpm" "hirs4_metop-a" "hirs4_n18" "hirs4_n19" "iasi_metop-a" "iasi_metop-b"
#                    "mhs_metop-a" "mhs_metop-b" "mhs_metop-c" "mhs_n19" "seviri_m08" "ssmis_f17"
#                    "ssmis_f18" )

declare -a sensors=("amsr2_gcom-w1" "gmi_gpm")



for sensor in ${sensors[@]}; do
  echo $sensor
  grep -i $sensor ana_satbias_rst.txt | awk '{print $2" "$3" "$4}' > ${outdirbias}/gsi.${exp}.bc.${sensor}.${pyyyy}-${pmm}-${pdd}T${phh}:00:00Z.tlapse
done

module unload core/anaconda/3.8
$iodabin/satbias2ioda.x satbias_converter_gcom_gmi.yaml

rename satbias_ gsi.$exp.bc. *nc4
rename .nc4 .${pyyyy}-${pmm}-${pdd}T${phh}:00:00Z.satbias *nc4
mv *satbias ${outdirbias}/

cd ../
