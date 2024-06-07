#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-n noddi/results] [-n setflow/results] [-w freewater_flow/results] [-f freesurfer_flow/results] [-o output]" 1>&2; exit 1; }

while getopts "r:t:n:f:o:" args; do
    case "${args}" in
        t) t=${OPTARG};;
        n) n=${OPTARG};;
        s) s=${OPTARG};;
        f) f=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${f}" ] || [ -z "${t}" ] || [ -z "${o}" ]; then
    usage
fi

echo "tractoflow results folder: ${t}"
echo "noddi_flow results folder: ${n}"
echo "freewater_flow results folder: ${w}"
echo "freesurfer_flow results folder: ${f}"
echo "setflow results folder: ${s}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd ${r}
for i in *;
do
    echo $i
    mkdir -p $o/$i/

    # tractoflow metrics
    ln -s $t/$i/DTI_Metrics/*fa.nii.gz $o/$i/metrics/fa.nii.gz
    ln -s $t/$i/DTI_Metrics/*ad.nii.gz $o/$i/metrics/ad.nii.gz
    ln -s $t/$i/DTI_Metrics/*md.nii.gz $o/$i/metrics/md.nii.gz
    ln -s $t/$i/DTI_Metrics/*rd.nii.gz $o/$i/metrics/rd.nii.gz
    ln -s $t/$i/FODF_Metrics/*afd_total.nii.gz $o/$i/metrics/afd_total.nii.gz
    ln -s $t/$i/FODF_Metrics/*nufo.nii.gz $o/$i/metrics/nufo.nii.gz

    # Peaks and FODF
    ln -s $t/$i/FODF_Metrics/*peak.nii.gz $o/$i/peaks.nii.gz
    ln -s $t/$i/FODF_Metrics/*fodf.nii.gz $o/$i/fodf.nii.gz

    # T1
    ln -s -e $t/${i}/Register_T1/*__output0GenericAffine.mat $o/${i}/output0GenericAffine.mat
    ln -s -e $t/${i}/Register_T1/*__1Warp.nii.gz $o/${i}/1Warp.nii.gz
    ln -s -e $t/${i}/Bet_T1/*__t1_bet.nii.gz $o/${i}/t1.nii.gz

    # DWI
    ln -s -e $t/${i}/Resample_DWI/*__dwi_resampled.nii.gz $o/${i}/dwi.nii.gz
    ln -s -e $t/${i}/Eddy*/*__bval_eddy $o/${i}/dwi.bval
    ln -s -e $t/${i}/Eddy*/*__dwi_eddy_corrected.bvec $o/${i}/dwi.bvec

    if [[ ! -z "${s}" ]];
    then
      # Tracking from SET
      ln -s ${s}/${i}/---------/*.trk ${o}/${i}/
    else
      # Tracking from Tractoflow
      ln -s ${t}/${i}/*Tracking/*.trk ${o}/${i}/
    end

    # noddi_flow metrics
    if [[ ! -z "${n}" ]];
    then
      ln -s $n/$i/Compute_NODDI/*OD.nii.gz $o/$i/metrics/noddi_od.nii.gz
      ln -s $n/$i/Compute_NODDI/*ISOVF.nii.gz $o/$i/metrics/noddi_isovf.nii.gz
      ln -s $n/$i/Compute_NODDI/*ICVF.nii.gz $o/$i/metrics/noddi_icvf.nii.gz
    fi

    # freewater_flow metrics
    if [[ ! -z "${w}" ]];
    then
      ln -s $w/$i/Compute_FreeWater/*FW.nii.gz $o/$i/metrics/freewater.nii.gz
      ln -s $w/$i/FW_Corrected_Metrics/*fa.nii.gz $o/$i/metrics/FAt.nii.gz
      ln -s $w/$i/FW_Corrected_Metrics/*ad.nii.gz $o/$i/metrics/ADt.nii.gz
      ln -s $w/$i/FW_Corrected_Metrics/*rd.nii.gz $o/$i/metrics/RDt.nii.gz
    fi

    # freesurfer_flow template
    if [[ ! -z "${w}" ]];
    then
      ln -s $w/$i/Generate_Atlases_FS_BN_GL_SF/atlas_brainnetome_v*.nii.gz $o/${i}/labels.nii.gz
      ln -s $w/$i/Generate_Atlases_FS_BN_GL_SF/labels_list.txt $o/labels_list.txt
    fi
done
echo "Done"