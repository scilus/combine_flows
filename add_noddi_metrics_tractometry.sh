#!/usr/bin/env bash
usage() { echo "$(basename $0) [-n noddi/results] [-o output]" 1>&2; exit 1; }

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

echo "noddi_flow results folder: ${n}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd ${n}
for i in *[!Compute_Kernel]; 
do
    echo $i
    mkdir -p $o/$i/metrics/

    # noddi_flow metrics
    ln -s $n/$i/Compute_NODDI/*OD.nii.gz $o/$i/metrics/noddi_od.nii.gz
    ln -s $n/$i/Compute_NODDI/*ISOVF.nii.gz $o/$i/metrics/noddi_isovf.nii.gz
    ln -s $n/$i/Compute_NODDI/*ICVF.nii.gz $o/$i/metrics/noddi_icvf.nii.gz
done
echo "Done"
