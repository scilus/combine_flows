#!/usr/bin/env bash
usage() { echo "$(basename $0) [-d freewater_flow/results] [-o output]" 1>&2; exit 1; }

while getopts "d:o:" args; do
    case "${args}" in
        d) d=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${d}" ] || [ -z "${o}" ]; then
    usage
fi

echo "freewater_flow results folder: ${d}"
echo "Output folder: ${o}"

echo "Building tree..."
cd ${d}
mkdir -p $o
for i in *[!Compute_Kernel]; do
    echo $i

    ln -s $d/$i/Compute_FreeWater/*FW.nii.gz $o/${i}_FW.nii.gz

done
echo "Done"
