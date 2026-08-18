#!/usr/bin/env bash
set -eo pipefail

#
# ./postprocess_one_file.sh 10000
#

CODE=/ceph/users/atuna/work
PFLOW=${CODE}/maia/mlpf_postprocess/particleflow
TTBAR=${CODE}/maia/maia_noodling/experiments/simulate_ttbar.2026_07_08_10h14m00s/ttbar_reco

NUM=${1}
OUTPATH=$(pwd)
INPUT=${TTBAR}/ttbar_reco_${NUM}.slcio.edm4hep.root
echo "NUM=${NUM}"
echo "INPUT=${INPUT}"
echo "OUTPATH=${OUTPATH}"

source ${PFLOW}/.venv/bin/activate
# which python
# uv run python ${PFLOW}/mlpf/data/key4hep/postprocessing.py --input ${INPUT} --outpath ${OUTPATH} --detector maia
python ${PFLOW}/mlpf/data/key4hep/postprocessing.py --input ${INPUT} --outpath ${OUTPATH} --detector maia
