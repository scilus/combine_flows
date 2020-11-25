#!/usr/bin/env bash
usage() { echo "$(basename $0) [-n freewater_flow/results] [-o output]" 1>&2; exit 1; }

while getopts "n:o:" args; do
    case "${args}" in
        n) n=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${n}" ] || [ -z "${o}" ]; then
    usage
fi

echo "freewater_flow results folder: ${n}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd ${n}
for i in *[!Compute_Kernel]; 
do
    echo $i
    mkdir -p $o/$i/metrics/

    # freewater_flow metrics
    ln -s $n/$i/Compute_FreeWater/*FW.nii.gz $o/$i/metrics/freewater.nii.gz
    ln -s $n/$i/FW_Corrected_Metrics/*fa.nii.gz $o/$i/metrics/FAt.nii.gz
    ln -s $n/$i/FW_Corrected_Metrics/*ad.nii.gz $o/$i/metrics/ADt.nii.gz
    ln -s $n/$i/FW_Corrected_Metrics/*rd.nii.gz $o/$i/metrics/RDt.nii.gz

done
echo "Done"
