#!/bin/bash

cd /lustre04/scratch/nclarke/adni_bids_output_func/

echo touch .bidsignore
echo '*T1w_cropped.nii' > .bidsignore

echo 'Done!'