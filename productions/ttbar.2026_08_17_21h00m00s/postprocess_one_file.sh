#!/usr/bin/env bash
set -eo pipefail

# paths
CODE=/ceph/users/atuna/work
PFLOW=${CODE}/maia/mlpf_postprocess/particleflow
TTBAR=${CODE}/maia/maia_noodling/experiments/simulate_ttbar.2026_07_08_10h14m00s/ttbar_reco

NUM=${1}
OUTPATH=$(pwd)
INPUT=${TTBAR}/ttbar_reco_${NUM}.slcio.edm4hep.root
echo "NUM=${NUM}"
echo "INPUT=${INPUT}"
echo "OUTPATH=${OUTPATH}"

# preamble
python --version || true

# env
python -m venv ./env
source env/bin/activate
python -m pip install awkward fastjet numpy tqdm uproot vector scipy pydantic comet_ml pyyaml pyarrow

# particleflow
export PYTHONPATH=/ceph/users/atuna/work/maia/mlpf_postprocess/particleflow

# run
python ${PFLOW}/mlpf/data/key4hep/postprocessing.py --input ${INPUT} --outpath ${OUTPATH} --detector maia

# cleanup
rm -rf ./env
