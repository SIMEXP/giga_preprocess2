
DATASET=adhd200
GIGA_AUTO_QC_VERSION=0.3.3
QC_OUTPUT=${SCRATCH}/${DATASET}_giga-auto-qc-${GIGA_AUTO_QC_VERSION}/
NEARLINE_ROOT="/nearline/ctb-pbellec/giga_preprocessing_2"

cd $QC_OUTPUT
tar -vczf ${NEARLINE_ROOT}/${DATASET}_fmriprep-20.2.7lts/${DATASET}_giga-auto-qc-${GIGA_AUTO_QC_VERSION}.tar.gz .
