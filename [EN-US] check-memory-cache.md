# how to check the memory cache consume

**server specification for this examples**
- Swap memory = 10GB 
- Physical memory = 28GB 

**Command**
```shellscript
-bash-3.2# uname -a
SunOS SERVERTEST 5.10 Generic_150400-62 sun4v sparc sun4v
```

```shellscript
-bash-3.2# swap -s
total: 87832k bytes allocated + 3952k reserved = 91784k used, 33816648k available
```

```shellscript
-bash-3.2# swap -l
swapfile             dev  swaplo blocks   free
/dev/dsk/c0d0s1     100,1      16 20496368 20496368
```

```shellscript
-bash-3.2# vmstat 2 2
 kthr      memory            page            disk          faults      cpu
 r b w   swap  free  re  mf pi po fr de sr vc -- -- --   in   sy   cs us sy id
 0 0 0 33859920 26366728 46 411 9 1 1 0  0  0  0  0  0 1157  954 1030  0  0 100
 1 0 0 33815328 25780520 30 332 28 0 0 0 0  0  0  0  0 1168 1232 1033  0  0 100
```

```shellscript
-bash-3.2# echo "::memstat" | mdb -k
Page Summary                Pages                MB  %Tot
------------     ----------------  ----------------  ----
Kernel                     221753              1732    6%
Anon                        14263               111    0%
Exec and libs                2866                22    0%
Page cache                 212380              1659    6%
Free (cachelist)          3210840             25084   87%
Free (freelist)              7914                61    0%
Total                    3670016             28672
```



root@SERVERTEST:~# echo "::memstat" | mdb "-k"
Page Summary                            Pages             Bytes  %Tot
---------------------------- ----------------  ----------------  ----
Kernel                                1627698             12.4G    5%
Defdump prealloc                       418625              3.1G    1%
ZFS                                  23569062            179.8G   71%
Anon                                   330673              2.5G    1%
Exec and libs                            3159             24.6M    0%
Page cache                             549896              4.1G    2%
Retired                                     4               32k    0%
Free (cachelist)                       319252              2.4G    1%
Free (freelist)                       6506687             49.6G   20%
Total                                33325056            254.2G

