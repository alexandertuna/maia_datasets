Making ttbar ML dataset from start (pythia8 card) to finish (postprocessed parquet)

To merge post-processed parquet files from individual jobs into one big parquet file, you can do, for example:

```bash
apptainer \
  exec \
  /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-ubuntu24:v2.9.8-amd64 \
  ./env_ubuntu24/bin/python merge_parquet_files.py \
  2026_10_20_v08_more_data/ \
  ttbar_reco_v08.parquet
```
