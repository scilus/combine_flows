#!/usr/bin/env bash
usage() { echo "$(basename $0) [-n noddi_flow/results] [-o output]" 1>&2; exit 1; }

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

echo "Building tree for following folders:"
cd ${n}
mkdir -p $o
for i in *[!Compute_Kernel]; do
    echo $i

    ln -s $n/$i/Compute_NODDI/*OD.nii.gz $o/${i}_noddi_OD.nii.gz
    ln -s $n/$i/Compute_NODDI/*ISOVF.nii.gz $o/${i}_noddi_ISOVF.nii.gz
    ln -s $n/$i/Compute_NODDI/*ICVF.nii.gz $o/${i}_noddi_ICVF.nii.gz

done
echo "Done"
