#!/usr/bin/env bash
usage() { echo "$(basename $0) [-f freewater_flow/results] [-o output]" 1>&2; exit 1; }

while getopts "f:o:" args; do
    case "${args}" in
        f) f=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${f}" ] || [ -z "${o}" ]; then
    usage
fi

echo "freewater_flow results folder: ${f}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd ${f}
mkdir -p $o
for i in *[!Compute_Kernel]; do
    echo $i

    ln -s $f/$i/Compute_FreeWater/*FW.nii.gz $o/${i}_FW.nii.gz

done
echo "Done"
