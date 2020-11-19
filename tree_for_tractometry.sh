#!/usr/bin/env bash
usage() { echo "$(basename $0) [-r RBX] [-d human-nf/results] [-o output]" 1>&2; exit 1; }

while getopts "r:d:t:a:o:" args; do
    case "${args}" in
        r) r=${OPTARG};;
        d) d=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${r}" ] || [ -z "${d}" ] || [ -z "${o}" ]; then
    usage
fi

echo "RB2 folder: ${r}"
echo "human-nf folder: ${d}"
echo "Output folder: ${o}"


echo "Building tree..."
cd ${r}
for i in *;
do
    mkdir -p $o/$i/bundles
    mkdir -p $o/$i/metrics
    mkdir -p $o/$i/centroids

    
    # imeka pipeline
    # ln -s $r/$i/${i}__whole_brain_${t}_tracts_${a}_comp/*[!_group].trk $o/$i/bundles
    # ln -s $r/$i/${i}__whole_brain_${t}_tracts_${a}_comp_centroids/*.trk $o/$i/centroids
    # ln -s $d/$i/DTI_Metrics/*fa.nii.gz $o/$i/metrics/fa.nii.gz
    # ln -s $d/$i/DTI_Metrics/*ga.nii.gz $o/$i/metrics/ga.nii.gz
    # ln -s $d/$i/DTI_Metrics/*mode.nii.gz $o/$i/metrics/mode.nii.gz
    # ln -s $d/$i/DTI_Metrics/*norm.nii.gz $o/$i/metrics/norm.nii.gz
    # ln -s $d/$i/HARDI_Metrics/*apower.nii.gz $o/$i/metrics/apower.nii.gz
    # ln -s $d/$i/HARDI_Metrics/*gfa.nii.gz $o/$i/metrics/gfa.nii.gz
    # ln -s $d/$i/FODF_Metrics/*afd.nii.gz $o/$i/metrics/afd.nii.gz
    # ln -s $d/$i/FODF_Metrics/*afd_sum.nii.gz $o/$i/metrics/afd_sum.nii.gz
    # ln -s $d/$i/FODF_Metrics/*afd_total.nii.gz $o/$i/metrics/afd_total.nii.gz
    # ln -s $d/$i/FODF_Metrics/*nufo.nii.gz $o/$i/metrics/nufo.nii.gz
    # ln -s $d/$i/Remove_DTI_Metric_Outliers/*ad_ransac.nii.gz $o/$i/metrics/ad.nii.gz
    # ln -s $d/$i/Remove_DTI_Metric_Outliers/*md_ransac.nii.gz $o/$i/metrics/md.nii.gz
    # ln -s $d/$i/Remove_DTI_Metric_Outliers/*rd_ransac.nii.gz $o/$i/metrics/rd.nii.gz

    # human-nf pipeline
    ln -s $(readlink -e $r/$i/${i}__tracking/*[!_group].trk) $o/$i/bundles
    ln -s $r/$i/${i}__tracking_centroids/*[!_group].trk $o/$i/centroids
    ln -s $d/$i/DTI_Metrics/*fa.nii.gz $o/$i/metrics/fa.nii.gz
    ln -s $d/$i/DTI_Metrics/*ga.nii.gz $o/$i/metrics/ga.nii.gz
    ln -s $d/$i/DTI_Metrics/*mode.nii.gz $o/$i/metrics/mode.nii.gz
    ln -s $d/$i/DTI_Metrics/*norm.nii.gz $o/$i/metrics/norm.nii.gz
    ln -s $d/$i/DTI_Metrics/*ad.nii.gz $o/$i/metrics/ad.nii.gz
    ln -s $d/$i/DTI_Metrics/*md.nii.gz $o/$i/metrics/md.nii.gz
    ln -s $d/$i/DTI_Metrics/*rd.nii.gz $o/$i/metrics/rd.nii.gz
    ln -s $d/$i/FODF_Metrics/*afd_total.nii.gz $o/$i/metrics/afd_total.nii.gz
    ln -s $d/$i/FODF_Metrics/*nufo.nii.gz $o/$i/metrics/nufo.nii.gz
    # FW
    # FW corrected DTI

    
done
echo "Done"
