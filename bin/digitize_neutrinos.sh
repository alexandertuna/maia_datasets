#!/usr/bin/env bash
set -eo pipefail

# paths
CODE=/ceph/users/atuna/work/maia
DATA=${CODE}/maia_datasets/productions/bib.2026_08_14_17h18m00s
TYPEEVENT="neutrinoGun"

# env
# it would be cool if setup_mucoll existed out-of-the-box
# setup_mucoll
source /opt/spack/opt/spack/__spack_path_placeholder__/__spack_path_placeholder__/__spack_path_placeholder__/__spack_path_placeholder__/linux-x86_64/mucoll-stack-*/setup.sh
export MARLIN_DLL=$(readlink -e ${CODE}/MyBIBUtils/build/lib/libMyBIBUtils.so):${MARLIN_DLL}

for NBKG in 500 666 1000 1166 1333 1500; do

    # for RESOLUTIONUV in 0.000 0.005 0.010 0.020; do
    for RESOLUTIONUV in 0.010; do

        mkdir -p ${NBKG}_${RESOLUTIONUV}
        cd ${NBKG}_${RESOLUTIONUV}

        for NUM in $(seq 0 9); do

            # run
            echo "Running ${RESOLUTIONUV} ${NUM} ${NBKG} ..."
            python ../digitize_muons.py \
                   --gen \
                   --sim \
                   --digi \
                   --bib \
                   --num ${NUM} \
                   --ResolutionUV ${RESOLUTIONUV} \
                   --overlayMixNumberBackground ${NBKG} \
                   --data ${DATA} \
                   --typeevent ${TYPEEVENT} &> neutrinoGun_log_${NUM}.txt
        done

        cd ../

    done

done

echo "Done ^.^"
