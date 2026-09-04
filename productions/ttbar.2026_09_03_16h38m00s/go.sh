#!/usr/bin/env bash
set -eo pipefail

#
# apptainer run /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-alma9:v2.9.8-amd64
# setup_mucoll
# CODE=/ceph/users/atuna/work/maia
# export MARLIN_DLL=$(readlink -e ${CODE}/MyBIBUtils/build/lib/libMyBIBUtils.so):${MARLIN_DLL}
#

#
# command line args
#
SEED=10042
TOPDIR=/ceph/users/atuna/work/maia/maia_datasets/productions/ttbar.2026_09_03_16h38m00s
EVENTS_PER_JOB=10

#
# paths
#
CODE=/ceph/users/atuna/work/maia
COMPACT=${CODE}/detector-simulation/geometries/MAIA_v0/MAIA_v0.xml
PFLOW=${CODE}/maia/mlpf_postprocess/particleflow

#
# file names
#
TYPEEVENT="ttbar"
GEN_CMD=p8_mumu_tt_ecm10000_${SEED}.cmd
GEN_HEPMC=${TYPEEVENT}_${SEED}.hepmc
SIM_STEER=${TOPDIR}/sim_steer_GEN_CONDOR.py
SIM_SLCIO=${TYPEEVENT}_sim_${SEED}.slcio
REC_STEER=${TOPDIR}/steer_reco_${TYPEEVENT}.py
REC_SLCIO=${TYPEEVENT}_reco_${SEED}.slcio
REC_ROOT=${REC_SLCIO}.edm4hep.root
REC_PATCH=${TOPDIR}/patch.txt
GEN_LOG=log_gen_${SEED}.txt
SIM_LOG=log_sim_${SEED}.txt
REC_LOG=log_rec_${SEED}.txt
POST_LOG=log_post_${SEED}.txt

#
# gen
#
echo "Running gen ${SEED} ..."
cp ${TOPDIR}/p8_mumu_tt_ecm10000.cmd ${GEN_CMD}
sed -i s/12345/${SEED}/g ${GEN_CMD}
k4run \
    pythia.py \
    --Dumper.Filename ${GEN_HEPMC} \
    --Pythia8.PythiaInterface.pythiacard ${GEN_CMD} \
    &> ${GEN_LOG}

#
# sim
#
echo "Running sim ${SEED} ..."
ddsim \
    --inputFile ${GEN_HEPMC} \
    --steeringFile ${SIM_STEER} \
    --compactFile ${COMPACT} \
    --numberOfEvents ${EVENTS_PER_JOB} \
    --outputFile ${SIM_SLCIO} \
    &> ${SIM_LOG}

#
# rec
#
echo "Running rec ${SEED} ..."
# k4run ${REC_STEER} \
#      --TypeEvent ${TYPEEVENT} \
#      --InFileName ${SEED} \
#      --code ${CODE} \
#      --skipTrackerConing \
#      &> ${REC_LOG}
# lcio2edm4hep ${REC_SLCIO} ${REC_ROOT} ${REC_PATCH}

#
# postprocess
#
# python \
#     ${PFLOW}/mlpf/data/key4hep/postprocessing.py \
#     --input ${REC_ROOT} \
#     --outpath $(pwd) \
#     --detector maia \
#     &> ${POST_LOG}
