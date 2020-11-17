#!/usr/bin/env bash
usage() { echo "$(basename $0) [-d noddi_flow/results] [-o output]" 1>&2; exit 1; }

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

echo "noddi_flow results folder: ${d}"
echo "Output folder: ${o}"

echo "Building tree..."
cd ${d}
for i in *[!Compute_Kernel]; do
    echo $i
    mkdir -p $o/$i
    
    # tractoflow pipeline
    ln -s $d/$i/Compute_NODDI/*OD.nii.gz $o/$i/noddi_OD.nii.gz
    ln -s $d/$i/Compute_NODDI/*ISOVF.nii.gz $o/$i/noddi_ISOVF.nii.gz
    ln -s $d/$i/Compute_NODDI/*ICVF.nii.gz $o/$i/noddi_ICVF.nii.gz

done
echo "Done"
