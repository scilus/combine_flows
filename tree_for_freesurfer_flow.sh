#!/usr/bin/env bash
usage() { echo "$(basename $0) [-f freesurfer output folder] [-o output]" 1>&2; exit 1; }

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

echo "freesurfer output folder: ${f}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd $f
for i in *[!{FRF}]; 
do
   echo $i
   mkdir -p $o

   ln -s $(readlink -e $f/${i}) $o/; 
done







