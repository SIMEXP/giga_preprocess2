#!/bin/bash

cd /home/nclarke/scratch/compass-nd/bids_release_7

cat <<EOF > .bidsignore
fmap/
dwi/
*FLAIR*
*PD*

EOF

echo 'Done!'
