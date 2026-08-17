# maia_datasets

## Miscellaneous

### Resources for condor jobs

Here are some one-liners for reporting the memory and disk usage of condor jobs:

```bash
grep "Memory (MB)" logs/condor.* | awk '{print $5}' | sort -nr
grep "Disk (KB)" logs/condor.* | awk '{print $5}' | sort -nr
```
