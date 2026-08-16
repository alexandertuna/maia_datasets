# Source me from the top-level maia_doublets dir
apptainer exec "/cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-alma9:v2.9.8-amd64" bash --rcfile env/mucollrc -i

# Below: the old approach
# NB: need to run `setup_mucoll` after starting the v2.9.8 container
# apptainer run /cvmfs/unpacked.cern.ch/gitlab-registry.cern.ch/muon-collider/mucoll-deploy/mucoll:2.9-alma9
# apptainer run /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-alma9\:v2.9.7
###### apptainer run /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-alma9:v2.9.8-amd64
# apptainer run /cvmfs/unpacked.cern.ch/ghcr.io/muoncollidersoft/mucoll-sim-ubuntu24:v2.11-amd64
