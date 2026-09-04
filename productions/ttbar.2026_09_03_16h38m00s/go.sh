#!/usr/bin/env bash
set -eo pipefail

#
# apptainer run /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-alma9:v2.9.8-amd64
# setup_mucoll
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

#
# file names
#
GEN_CMD=p8_mumu_tt_ecm10000_${SEED}.cmd
GEN_HEPMC=ttbar_${SEED}.hepmc
SIM_STEER=${TOPDIR}/sim_steer_GEN_CONDOR.py
SIM_SLCIO=ttbar_sim_${SEED}.slcio

#
# gen
#
cp ${TOPDIR}/p8_mumu_tt_ecm10000.cmd ${GEN_CMD}
sed -i s/12345/${SEED}/g ${GEN_CMD}
time k4run pythia.py --Dumper.Filename ${GEN_HEPMC} --Pythia8.PythiaInterface.pythiacard ${GEN_CMD}

#
# sim
#
time ddsim \
     --inputFile ${GEN_HEPMC} \
     --steeringFile ${SIM_STEER} \
     --compactFile ${COMPACT} \
     --numberOfEvents ${EVENTS_PER_JOB} \
     --outputFile ${SIM_SLCIO}

#
# reco
#

#
# postprocess
#
