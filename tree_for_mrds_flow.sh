#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-o output] [-s tracking]" 1>&2; exit 1; }

while getopts "t:o:s:" args; do
    case "${args}" in
        t) t=${OPTARG};;
        o) o=${OPTARG};;
        s) s=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${t}" ] || [ -z "${o}" ] || [ -z "${s}" ]; then
    usage
fi

if [ "${s}" != "local_tracking" ] && [ "${s}" != "pft_tracking" ]; then
    echo "Invalid tracking type: ${s}"
    echo "Valid options for -s are 'local_tracking' or 'pft_tracking'."
    exit 1
fi

echo "tractoflow folder: ${t}"
echo "Output folder: ${o}"
echo "Tracking type: ${s}"

echo "Building tree for the following folders:"
cd $t
for i in *[!{FRF}]; 
do
    echo $i
    mkdir -p $o/$i

    ln -s ${t}/${i}/Resample_DWI/*dwi_resampled.nii.gz ${o}/${i}/dwi.nii.gz
    ln -s ${t}/${i}/Eddy_Topup/*dwi_eddy_corrected.bvec ${o}/${i}/dwi.bvec
    ln -s ${t}/${i}/Eddy_Topup/*bval_eddy ${o}/${i}/dwi.bval
    if [ "$s" == "local_tracking" ]; then
        ln -s ${t}/${i}/Local_Tracking/*local_tracking_prob_wm_seeding_wm_mask_seed_0.trk ${o}/${i}/local_tracking.trk
        ln -s ${t}/${i}/Local_Tracking_Mask/*local_tracking_mask.nii.gz ${o}/${i}/mask.nii.gz
    elif [ "$s" == "pft_tracking" ]; then
        ln -s ${t}/${i}/PFT_Tracking/*pft_tracking_prob_interface_seed_0.trk ${o}/${i}/pft_tracking.trk
        ln -s ${t}/${i}/PFT_Tracking_Maps/*map_include.nii.gz ${o}/${i}/mask.nii.gz
    fi
done

rm -rf ${o}/Readme*
rm -rf ${o}/Read_BIDS