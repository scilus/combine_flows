#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-o output]" 1>&2; exit 1; }

while getopts "d:o:" args; do
    case "${args}" in
        d) t=${OPTARG};;
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

echo "Building tree..."
cd $t
for i in *[!{FRF}]; 
do
   echo $i
   mkdir -p $o/$i

   ln -s ${t}/${i}/Tracking/*.trk ${o}/${i}/
   ln -s ${t}/${i}/DTI_Metrics/*fa.nii.gz ${o}/${i}/
done

rm -rf ${o}/Readme*
rm -rf ${o}/Read_BIDS
