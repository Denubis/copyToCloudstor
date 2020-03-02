# copyToCloudstor
Rclone script to copy to cloudstor in paranoid while loop

```
./copyToCloudstor <src> <rcloneEndpoint:dest>
  --help              : This help
  --skipversioncheck  : Skip rclone version checking
  --nocheck           : Just pushes once without retrying
  -p|--parallel       : Number of file transfers to run in parallel. (default 6)
  --pushonce          : Just does a blind push (same as --nocheck --pushfirst)
  --pushfirst         : Skip first oneway check (one less propfind)
  --showdiff          : Show diff when checking for differences
```

## Requirements
- rclone
