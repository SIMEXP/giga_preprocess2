#!/bin/bash

cd /lustre04/scratch/nclarke/oasis3_bids

cat <<EOF > .bidsignore
*restingstateMB4*
*restMB4*
/**/**/dataset_description.json
*testrest*

EOF

echo 'Done!'
