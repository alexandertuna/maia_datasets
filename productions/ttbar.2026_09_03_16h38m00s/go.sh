#!/usr/bin/env bash
set -eo pipefail

#
# 1. set up environment before running
# export PYTHONPATH=""
# python -m venv ./env
# ./env/bin/python -m pip -q install --upgrade pip
# ./env/bin/python -m pip -q install awkward fastjet numpy tqdm uproot vector scipy pydantic comet_ml pyyaml pyarrow
#

#
# 2. and activate container like this when running locally
# apptainer run /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-alma9:v2.9.8-amd64
# setup_mucoll
# CODE=/ceph/users/atuna/work/maia
# export MARLIN_DLL=$(readlink -e ${CODE}/MyBIBUtils/build/lib/libMyBIBUtils.so):${MARLIN_DLL}
#

#
# command line args
#
if [ -z "$1" ]; then
    echo "Usage: $0 SEED"
    exit 1
fi
SEED=${1}
TOPDIR=/ceph/users/atuna/work/maia/maia_datasets/productions/ttbar.2026_09_03_16h38m00s
# EVENTS_PER_JOB=1

#
# steering
#
DO_GEN=true
DO_SIM=true
DO_REC=true
DO_POST=true

#
# paths
#
CODE=/ceph/users/atuna/work/maia
COMPACT=${CODE}/detector-simulation/geometries/MAIA_v0/MAIA_v0.xml
PFLOW=${CODE}/mlpf_postprocess/particleflow

#
# file names
#
TYPEEVENT="ttbar"
GEN_TEMPLATE=p8_mumu_tt_ecm10000.cmd
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
if $DO_GEN; then
    echo "Running gen ${SEED} ..."
    cp ${TOPDIR}/${GEN_TEMPLATE} ${GEN_CMD}
    sed -i s/12345/${SEED}/g ${GEN_CMD}
    k4run \
        pythia.py \
        --Dumper.Filename ${GEN_HEPMC} \
        --Pythia8.PythiaInterface.pythiacard ${GEN_CMD} \
        &> ${GEN_LOG}
fi

#
# sim
#
if $DO_SIM; then
    echo "Running sim ${SEED} ..."
    ddsim \
        --inputFile ${GEN_HEPMC} \
        --outputFile ${SIM_SLCIO} \
        --steeringFile ${SIM_STEER} \
        --compactFile ${COMPACT} \
        &> ${SIM_LOG}
        # --numberOfEvents ${EVENTS_PER_JOB} \
fi

#
# rec
#
if $DO_REC; then
    echo "Running rec ${SEED} ..."
    k4run ${REC_STEER} \
         --TypeEvent ${TYPEEVENT} \
         --InFileName ${SEED} \
         --code ${CODE} \
         --skipTrackerConing \
         &> ${REC_LOG}
    lcio2edm4hep ${REC_SLCIO} ${REC_ROOT} ${REC_PATCH}
fi

#
# postprocess
#
if $DO_POST; then
    echo "Running post-processing ${SEED} ..."
    export PYTHONPATH=${PFLOW}
    ${TOPDIR}/env/bin/python \
        ${PFLOW}/mlpf/data/key4hep/postprocessing.py \
        --input ${REC_ROOT} \
        --outpath $(pwd) \
        --detector maia \
        &> ${POST_LOG}
fi
