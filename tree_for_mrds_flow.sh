#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-s schemes] [-o output]" 1>&2; exit 1; }

while getopts "t:s:o:" args; do
    case "${args}" in
        t) t=${OPTARG};;
        s) s=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${t}" ] || [ -z "${s}" ] || [ -z "${o}" ]; then
    usage
fi

echo "tractoflow folder: ${t}"
echo "scheme folder: ${s}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd $t
for i in *[!{FRF}]; 
do
    echo $i
    mkdir -p $o/$i

    ln -s ${t}/${i}/Resample_DWI/*dwi_resampled.nii.gz ${o}/${i}/dwi.nii.gz
    ln -s ${t}/${i}/Local_Tracking/*local_tracking_prob_wm_seeding_wm_mask_seed_0.trk ${o}/${i}/tracking.trk
    ln -s ${t}/${i}/Local_Tracking_Mask/*local_tracking_mask.nii.gz ${o}/${i}/mask.nii.gz
    ln -s ${s}/${i}/dwi/*.bvec ${o}/${i}/dwi.bvec
    ln -s ${s}/${i}/dwi/*.bval ${o}/${i}/dwi.bval
done

rm -rf ${o}/Readme*
rm -rf ${o}/Read_BIDS