#!/usr/bin/env bash
set -eo pipefail

#
# apptainer run /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-alma9:v2.9.8-amd64
# setup_mucoll
#
SEED=10042
TOPDIR=/ceph/users/atuna/work/maia/maia_datasets/productions/ttbar.2026_09_03_16h38m00s

#
# file names
#
CARD=p8_mumu_tt_ecm10000_${SEED}.cmd
HEPMC=ttbar_${SEED}.hepmc

#
# gen
#
cp ${TOPDIR}/p8_mumu_tt_ecm10000.cmd ${CARD}
sed -i s/12345/${SEED}/g ${CARD}
time k4run pythia.py --Dumper.Filename ${HEPMC} --Pythia8.PythiaInterface.pythiacard ${CARD}

#
# sim
#

#
# reco
#

#
# postprocess
#
