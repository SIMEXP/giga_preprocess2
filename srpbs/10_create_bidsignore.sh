#!/bin/bash

cd /lustre04/scratch/nclarke/SRPBS_OPEN_bids

cat <<EOF > .bidsignore
fmap/
EOF

echo 'Done!'
