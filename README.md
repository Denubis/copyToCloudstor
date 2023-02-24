# copyToCloudstor
Rclone script to copy to cloudstor in paranoid while loop

```
copyToCloudstor <src> CloudStor:<dest>
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

## Example

```
laptop@work:/datasets$ ./copyToCloudstor.sh dataset.1 CloudStor:/datasets/
rclone is latest version.
Copying /datasets/dataset.1 to CloudStor:/datasets/. Starting at Fri Feb 24 03:05:09 PM AEDT 2023
2023/02/24 15:05:09 ERROR : dataset.1: file not in webdav root 'datasets'
2023/02/24 15:05:09 NOTICE: webdav root 'datasets': 1 files missing
2023/02/24 15:05:09 NOTICE: webdav root 'datasets': 1 differences found
2023/02/24 15:05:09 NOTICE: webdav root 'datasets': 1 errors while checking
2023/02/24 15:05:09 Failed to check: 1 differences found
Starting run 1 at Fri Feb 24 03:05:10 PM AEDT 2023
Transferred:            799 B / 799 B, 100%, 266 B/s, ETA 0s
Transferred:            1 / 1, 100%
Elapsed time:         4.1s
Done with run 1 at Fri Feb 24 03:05:14 PM AEDT 2023
2023/02/24 15:05:14 NOTICE: webdav root 'datasets': 0 differences found
2023/02/24 15:05:14 NOTICE: webdav root 'datasets': 1 matching files
2023/02/24 15:05:14 NOTICE: webdav root 'datasets': 0 differences found
Copied 'dataset.1' to 'CloudStor:/datasets/'. Finished at Fri Feb 24 03:05:14 PM AEDT 2023, in 0 minutes and 5 seconds elapsed.
```

## Help setting up rclone to use CloudStor
- [Can I use the command line or WebDav? – AARNet Knowledge Base](https://support.aarnet.edu.au/hc/en-us/articles/115007168507-Can-I-use-the-command-line-or-WebDav-)
