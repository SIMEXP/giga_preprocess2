cp -r nearline/ctb-pbellec/giga_preprocessing_2/abide1_fmriprep-20.2.7lts/abide1_fmriprep-20.2.7lts \
    ~/scratch/

cd ~/scratch/abide1_fmriprep-20.2.7lts

SITES=`ls`

for site in ${SITES}; do
    site_name="${site%.*.*}"
    mkdir -p ~/scratch/abide1_fmriprep-20.2.7lts/$site_name
    tar -xvf $site_name.tar.gz -C $site_name 
done
