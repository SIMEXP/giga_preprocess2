NEARLINE=~/nearline/ctb-pbellec/giga_preprocessing_2/abide1_fmriprep-20.2.7lts/abide1_fmriprep-20.2.7lts/
mkdir ~/scratch/abide1_fmriprep-20.2.7lts

SITES=`ls $NEARLINE`

for site in ${SITES}; do
    site_name="${site%.*}"
    echo $site_name
    mkdir -p ~/scratch/abide2_fmriprep-20.2.7lts/$site_name
    tar -xf ${NEARLINE}/$site_name.tar \
        -C ~/scratch/abide2_fmriprep-20.2.7lts/$site_name \
        --wildcards "./fmriprep-20.2.7lts/sub-*/" \
        --strip-components=2 \
        --skip-old-files &
done


NEARLINE=~/nearline/ctb-pbellec/giga_preprocessing_2/abide2_fmriprep-20.2.7lts/abide2_fmriprep-20.2.7lts/
mkdir ~/scratch/abide2_fmriprep-20.2.7lts

SITES=`ls $NEARLINE`

for site in ${SITES}; do
    site_name="${site%.*}"
    echo $site_name
    mkdir -p ~/scratch/abide2_fmriprep-20.2.7lts/$site_name
    
    tar -xf ${NEARLINE}/$site_name.tar \
        -C ~/scratch/abide2_fmriprep-20.2.7lts/$site_name \
        --wildcards "./fmriprep-20.2.7lts/sub-*/*/" \
        --strip-components=2 \
        --skip-old-files &
done
