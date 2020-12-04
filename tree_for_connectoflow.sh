#!/usr/bin/env bash
usage() { echo "$(basename $0) [-t tractoflow/results] [-f freesurfer_flow/results] [-o output]" 1>&2; exit 1; }

while getopts "t:f:o:" args; do
    case "${args}" in
        t) t=${OPTARG};;
	f) f=${OPTARG};;
        o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${t}" ] || [ -z "${f}" ] || [ -z "${o}" ]; then
    usage
fi

echo "tractoflow/results folder: ${t}"
echo "freesurfer_flow/results folder: ${f}"
echo "Output folder: ${o}"

echo "Building tree for the following folders:"
cd $t
for i in *[!{FRF}]; 
do
   echo $i
   mkdir -p $o/$i
   mkdir -p $o/$i/metrics
   
   #for i in ../../freesurfer_flow_092020/results_fs/sub-*; do mkdir $(basename $i); done
   #for i in */; do mkdir ${i}/metrics; done

   # get atlases
   ln -s $(readlink -e $f/${i}/Generate_Atlases_FS_BN_GL/atlas_brainnetome_v2.nii.gz) $o/${i}/brainnetome_labels.nii.gz; 
   ln -s $(readlink -e $f/${i}/Generate_Atlases_FS_BN_GL/atlas_freesurfer_v2.nii.gz) $o/${i}/freesurfer_labels.nii.gz; 

   # get tractoflow stuff for COMMIT/AFD_along_connections
   ln -s $(readlink -e $t/${i}//Resample_DWI/*__dwi_resampled.nii.gz) $o/${i}/dwi.nii.gz; 
   ln -s $(readlink -e $t/${i}/Eddy_Topup/*__bval_eddy) $o/${i}/dwi.bval; 
   ln -s $(readlink -e $t/${i}/Eddy_Topup/*__dwi_eddy_corrected.bvec) $o/${i}/dwi.bvec; 
   ln -s $(readlink -e $t/${i}/FODF_Metrics/*__fodf.nii.gz) $o/${i}/fodf.nii.gz; 
   ln -s $(readlink -e $t/${i}/FODF_Metrics/*__peaks.nii.gz) $o/${i}/peaks.nii.gz; 

   # get tractoflow stuff for registration between native t1 and MNI space
   ln -s $(readlink -e $t/${i}/Register_T1/*__output0GenericAffine.mat) $o/${i}/output0GenericAffine.mat; 
   ln -s $(readlink -e $t/${i}/Register_T1/*__output1Warp.nii.gz) $o/${i}/output1Warp.nii.gz; 
   ln -s $(readlink -e $t/${i}/Resample_T1/*__t1_resampled.nii.gz) $o/${i}/t1.nii.gz; 

   # get tractoflow metrics
   ln -s $(readlink -e $t/${i}/DTI_Metrics/*__fa.nii.gz) $o/${i}/metrics/fa.nii.gz;
   ln -s $(readlink -e $t/${i}/DTI_Metrics/*__md.nii.gz) $o/${i}/metrics/md.nii.gz;
   ln -s $(readlink -e $t/${i}/DTI_Metrics/*__ad.nii.gz) $o/${i}/metrics/ad.nii.gz;
   ln -s $(readlink -e $t/${i}/DTI_Metrics/*__rd.nii.gz) $o/${i}/metrics/rd.nii.gz;
   ln -s $(readlink -e $t/${i}/FODF_Metrics/*__afd_total.nii.gz)  $o/${i}/metrics/afd_tot.nii.gz;
   ln -s $(readlink -e $t/${i}/FODF_Metrics/*__nufo.nii.gz) $o/${i}/metrics/nufo.nii.gz;

   # TODO: add FW/NODDI metrics with -n -f ... conflict in -f convention...
   
   # Option Tractoflow with local tracking. Can we support this?
   ln -s $(readlink -e $t/${i}/Tracking/*.trk) $o/${i}/pft_tracking.trk;

done

rm -rf ${o}/Readme*
rm -rf ${o}/Read_BIDS







