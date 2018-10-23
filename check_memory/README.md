# check_memory

  a nagios check to determine memory and swap usage of *nix systems.  
  
 - initially derived from: https://github.com/whereisaaron/linux-check-mem-nagios-plugin/
 - refactored check to be more in line with output from tools like procps/htop
   and correctly calculate memory usage regarding to SReclaim/Shmem/Cache
 - added bash4 getopts parser
 - added option to report and alert on swap usage
 - added options to disable alert on mem/swap usage (always report 'OK', just show calculated values)
 - added warn/crit/max values in perfdata
 - added various sanity checks
 - see discussions / documentation:
   - https://stackoverflow.com/questions/41224738/how-to-calculate-system-memory-usage-from-proc-meminfo-like-htop
   - https://github.com/hishamhm/htop/issues/242
   - https://github.com/torvalds/linux/blob/master/Documentation/filesystems/proc.txt#L901
   - https://gitlab.com/procps-ng/procps/commit/05d751c4f076a2f0118b914c5e51cfbb4762ad8e  
   
## Commandline Options
```
  check_memory

    -h | --help             display help
    -u | --unit             either B, K, M or G. default: M
    -c | --mem-critical     memory critical threshold in percent. default: 90
    -w | --mem-warning      memory warning threshold in percent. default: 80
    -C | --swap-critical    swap critical threshold in percent. default: 50
    -W | --swap-warning     swap warning threshold in percent. default: 25
    -M | --no-mem-alert     mem usage above threshold does not trigger alert. default: false
    -S | --no-swap-alert    swap usage above threshold does not trigger alert. default: false
    -v | --verbose          display check states and calculated values. output can NOT be parsed by nagios,
                            for debugging only. default: false
```

## Sample Output
```
~# ./check_memory -w 80 -c 90

Memory usage OK: 111411MiB (98.76%) of 112805MiB, Effective memory usage: 48429MiB (42.93%) Swap usage: 0MiB (0.00%) | TotalMem=118284972032 TotalMemUsed=116823584768B;118284972032;118284972032;0;118284972032 EffectiveMemUsed=50782126080B;94627977625;106456474828;0;118284972032 SwapUsed=0B;15999958016;31999916032;0;63999832064
```

