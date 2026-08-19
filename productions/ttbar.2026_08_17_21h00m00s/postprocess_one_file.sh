#!/usr/bin/env bash
set -eo pipefail

# env
# it would be cool if setup_mucoll existed out-of-the-box
# setup_mucoll
# source /opt/spack/opt/spack/__spack_path_placeholder__/__spack_path_placeholder__/__spack_path_placeholder__/__spack_path_placeholder__/linux-x86_64/mucoll-stack-master-2wtmg3ohr26uckseodhqjfjaw7mijwil/setup.sh

# preamble
echo "SHELL=$SHELL"
echo "PWD=$PWD"
echo "HOST=$(hostname)"
which python || true
python --version || true
python3.10 --version || true
python3.11 --version || true
python3.12 --version || true

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

# env
python -m venv ./env
source env/bin/activate
python -m pip install awkward fastjet numpy tqdm uproot vector scipy pydantic comet_ml pyyaml pyarrow

# particleflow
export PYTHONPATH=/ceph/users/atuna/work/maia/mlpf_postprocess/particleflow
echo "PYTHONPATH"
echo "$PYTHONPATH"
ls $PYTHONPATH
# git clone --recurse-submodules https://github.com/jpata/particleflow.git
# python -m pip install --no-deps particleflow
# python -m pip install --no-deps /ceph/users/atuna/work/maia/mlpf_postprocess/particleflow_containered

# source ${PFLOW}/.venv/bin/activate
# which python
# python --version
python ${PFLOW}/mlpf/data/key4hep/postprocessing.py --input ${INPUT} --outpath ${OUTPATH} --detector maia
rm -rf ./env ./particleflow
