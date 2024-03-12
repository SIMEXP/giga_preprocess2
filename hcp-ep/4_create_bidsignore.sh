#!/bin/bash

cd /lustre04/scratch/nclarke/imagingcollection01

cat <<EOF > .bidsignore
manifests/
EOF

echo 'Done!'
