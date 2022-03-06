#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-r rbx/results_rbx/] [-n noddi/results] [-f freewater_flow/results] [-o output]" 1>&2; exit 1; }

while getopts "t:o:" args; do
    case "${args}" in
        t) t=${OPTARG};;
        r) r=${OPTARG};;
        n) n=${OPTARG};;
        f) f=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${t}" ] || [ -z "${o}" ]; then
    usage
fi

echo "tractoflow folder: ${t}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd $t
for i in *[!{FRF}];
do
   echo $i
   mkdir -p $o/${i}/{metrics,tractograms}

   ln -s $t/$i/Register_T1/${i}__t1_warped.nii.gz $o/$i/t1.nii.gz

   # tractoflow tractograms
   ln -s $t/$i/*Tracking/*.trk $o/$i/tractograms/

   # rbx tractograms
   if [[ ! -z "${r}" ]];
   then
     ln -s $r/$i/Clean_Bundles/*trk $o/$i/tractograms/
   fi

   # tractoflow metrics
   ln -s $t/$i/DTI_Metrics/*fa.nii.gz $o/$i/metrics/fa.nii.gz
   ln -s $t/$i/DTI_Metrics/*ad.nii.gz $o/$i/metrics/ad.nii.gz
   ln -s $t/$i/DTI_Metrics/*md.nii.gz $o/$i/metrics/md.nii.gz
   ln -s $t/$i/DTI_Metrics/*rd.nii.gz $o/$i/metrics/rd.nii.gz
   ln -s $t/$i/FODF_Metrics/*afd_total.nii.gz $o/$i/metrics/afd_total.nii.gz
   ln -s $t/$i/FODF_Metrics/*nufo.nii.gz $o/$i/metrics/nufo.nii.gz

   # noddi_flow metrics
   if [[ ! -z "${n}" ]];
   then
     ln -s $n/$i/Compute_NODDI/*OD.nii.gz $o/$i/metrics/noddi_od.nii.gz
     ln -s $n/$i/Compute_NODDI/*ISOVF.nii.gz $o/$i/metrics/noddi_isovf.nii.gz
     ln -s $n/$i/Compute_NODDI/*ICVF.nii.gz $o/$i/metrics/noddi_icvf.nii.gz
   fi

   # freewater_flow metrics
   if [[ ! -z "${f}" ]];
   then
     ln -s $f/$i/Compute_FreeWater/*FW.nii.gz $o/$i/metrics/freewater.nii.gz
     ln -s $f/$i/FW_Corrected_Metrics/*fa.nii.gz $o/$i/metrics/FAt.nii.gz
     ln -s $f/$i/FW_Corrected_Metrics/*ad.nii.gz $o/$i/metrics/ADt.nii.gz
     ln -s $f/$i/FW_Corrected_Metrics/*rd.nii.gz $o/$i/metrics/RDt.nii.gz
   fi

done

rm -rf ${o}/Readme*
rm -rf ${o}/Read_BIDS
