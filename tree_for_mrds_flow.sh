#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-o output]" 1>&2; exit 1; }

while getopts "t:o:" args; do
    case "${args}" in
        t) t=${OPTARG};;
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
    mkdir -p $o/$i

    ln -s ${t}/${i}/Resample_DWI/*dwi_resampled.nii.gz ${o}/${i}/dwi.nii.gz
    ln -s ${t}/${i}/Eddy_Topup/*dwi_eddy_corrected.bvec ${o}/${i}/dwi.bvec
    ln -s ${t}/${i}/Eddy_Topup/*bval_eddy ${o}/${i}/dwi.bval
    ln -s ${t}/${i}/Local_Tracking_Mask/*local_tracking_mask.nii.gz ${o}/${i}/mask.nii.gz
    ln -s ${t}/${i}/Local_Tracking/*local_tracking_prob_wm_seeding_wm_mask_seed_0.trk ${o}/${i}/local_tracking.trk
    ln -s ${t}/${i}/PFT_Tracking/*pft_tracking_prob_interface_seed_0.trk ${o}/${i}/pft_tracking.trk
done

rm -rf ${o}/Readme*
rm -rf ${o}/Read_BIDS