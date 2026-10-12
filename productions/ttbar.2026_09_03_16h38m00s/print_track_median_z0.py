import awkward as ak
import pandas as pd
import numpy as np

# from mlpf.conf import EDM4HEP
from typing import Any
from dataclasses import dataclass, fields
class EDM4HEP:
    @dataclass
    class TrackFeatures:
        elemtype: Any
        pt: Any
        eta: Any
        sin_phi: Any
        cos_phi: Any
        p: Any
        chi2: Any
        ndf: Any
        dEdx: Any
        dEdxError: Any
        radiusOfInnermostHit: Any
        tanLambda: Any
        D0: Any
        omega: Any
        Z0: Any
        time: Any

        @classmethod
        def get_names(cls):
            return [f.name for f in fields(cls)]


names = EDM4HEP.TrackFeatures.get_names()
iz0 = names.index("Z0")

df = pd.read_parquet("/ceph/users/atuna/public_html/muoncollider/data/mlpf/ttbar/v07/ttbar_reco.parquet")

z0 = []
nev = 0
for batch in df["X_track"]:
    for ev in batch:
        nev += 1
        if len(ev) > 0:
            z0.append(np.vstack(ev)[:, iz0])

flat = np.concatenate(z0)
print(f"events with tracks: {len(z0)} / {nev}")
print(f"all tracks: mean = {flat.mean():.3f} mm")
print(f"all tracks: std = {flat.std():.3f} mm")

pv_z = np.array([np.median(z) for z in z0])
print(f"per-event median: mean = {pv_z.mean():.3f} mm")
print(f"per-event median: std = {pv_z.std():.3f} mm")
