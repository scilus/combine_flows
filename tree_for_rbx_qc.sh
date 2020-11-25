#!/usr/bin/env bash
usage() { echo "$(basename $0) [-r rbx_flow/results] [-o output]" 1>&2; exit 1; }

while getopts "r:o:" args; do
    case "${args}" in
        r) r=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${r}" ] || [ -z "${o}" ]; then
    usage
fi

echo "rbx_flow folder: ${r}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd ${r}
for j in *;
do
   echo $j
   mkdir -p $o/$j

   ln -s ${r}/${j}/Clean_Bundles/*.trk ${o}/${j}/
   ln -s ${r}/${j}/Register_Anat/*outputWarped.nii.gz ${o}/${j}/${j}__anat.nii.gz
done

for b in ${o}/${j}/*.trk;
do
    mv $b ${b%%_m_cleaned.trk}.trk
done
