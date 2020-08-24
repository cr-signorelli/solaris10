# Solaris 10 - Espelhamento de disco via ZFS

---

Status do espelhando de discos, para um sistema instalado ou usando ZFS.
```console
bash-3.2# zpool status
  pool: rpool
  state: ONLINE
  scan: none requested
  config:

        NAME                       STATE     READ WRITE CKSUM
        rpool                      ONLINE       0     0     0
        c0t361CEB4725D71723d0s0    ONLINE       0     0     0
  
  errors: No known data errors
```

Primeiro vamos localizar os discos.
```console
bash-3.2# ls /dev/rdsk/*s0
    /dev/rdsk/c0t361CEB4725D71723d0s0   /dev/rdsk/c0t3B7CA031337740CDd0s0   /dev/rdsk/c1t6d0s0   /dev/rdsk/c2t0d0s0
```

Vamos preparar o RAID do Solaris.
```console
bash-3.2# zpool attach -f rpool c0t361CEB4725D71723d0s0 c0t3B7CA031337740CDd0s0
```

---

**Em caso de erro, é preciso ajustar os slices do disco antes.**

Em caso de erro no espelhamento do RAID, será necessário acertar os slices dos disco.
```console
bash-3.2# zpool attach -f rpool c0t361CEB4725D71723d0s0 c0t3B7CA031337740CDd0s0
    cannot attach c0t3B7CA031337740CDd0s0 to c0t361CEB4725D71723d0s0: device is too small
```

Verificar os slices do disco 1.
```console
bash-3.2# prtvtoc /dev/rdsk/c0t361CEB4725D71723d0s0
    * /dev/rdsk/c0t361CEB4725D71723d0s0 partition map
    *
    * Dimensions:
    *     512 bytes/sector
    *     139 sectors/track
    *     128 tracks/cylinder
    *   17792 sectors/cylinder
    *   65535 cylinders
    *   65533 accessible cylinders
    *
    * Flags:
    *   1: unmountable
    *  10: read-only
    *
    *                          First     Sector    Last
    * Partition  Tag  Flags    Sector     Count    Sector  Mount Directory
           0      2    00          0 1165963136 1165963135
           2      5    00          0 1165963136 1165963135
```

Verificar os slices do disco 2.
```console
bash-3.2# prtvtoc /dev/rdsk/c0t3B7CA031337740CDd0s0
    * /dev/rdsk/c0t3B7CA031337740CDd0s0 partition map
    *
    * Dimensions:
    *     512 bytes/sector
    *     139 sectors/track
    *     128 tracks/cylinder
    *   17792 sectors/cylinder
    *   65535 cylinders
    *   65533 accessible cylinders
    *
    * Flags:
    *   1: unmountable
    *  10: read-only
    *
    *                          First     Sector    Last
    * Partition  Tag  Flags    Sector     Count    Sector  Mount Directory
           0      2    00          0    266880    266879
           1      3    01     266880    266880    533759
           2      5    01          0 1165963136 1165963135
           6      4    00     533760 1165429376 1165963135
```
    
Veja que os slices estao diferentes, nesse caso é preciso deixar os dois iguais antes de dar um attach.

O modelo correto é o que esta com 2 slices só, vamos criar um arquivo de modelo usando ele como referência.
```console
bash-3.2# prtvtoc /dev/rdsk/c0t361CEB4725D71723d0s0 > /tmp/volume1.out
```

Use o arquivo do modelo e aplicar no disco.
```
bash-3.2# fmthard -s /tmp/volume1.out /dev/rdsk/c0t3B7CA031337740CDd0s0
    fmthard:  New volume table of contents now in place.
``` 

Verifique os slices do disco 1.
```
bash-3.2# prtvtoc /dev/rdsk/c0t361CEB4725D71723d0s0
    * /dev/rdsk/c0t361CEB4725D71723d0s0 partition map
    *
    * Dimensions:
    *     512 bytes/sector
    *     139 sectors/track
    *     128 tracks/cylinder
    *   17792 sectors/cylinder
    *   65535 cylinders
    *   65533 accessible cylinders
    *
    * Flags:
    *   1: unmountable
    *  10: read-only
    *
    *                          First     Sector    Last
    * Partition  Tag  Flags    Sector     Count    Sector  Mount Directory
           0      2    00          0 1165963136 1165963135
           2      5    00          0 1165963136 1165963135
```
    
Verifique os slices do disco 2, agora ambos os discos estão iguais.
```
bash-3.2# prtvtoc /dev/rdsk/c0t3B7CA031337740CDd0s0
    * /dev/rdsk/c0t3B7CA031337740CDd0s0 partition map
    *
    * Dimensions:
    *     512 bytes/sector
    *     139 sectors/track
    *     128 tracks/cylinder
    *   17792 sectors/cylinder
    *   65535 cylinders
    *   65533 accessible cylinders
    *
    * Flags:
    *   1: unmountable
    *  10: read-only
    *
    *                          First     Sector    Last
    * Partition  Tag  Flags    Sector     Count    Sector  Mount Directory
           0      2    00          0 1165963136 1165963135
           2      5    00          0 1165963136 1165963135
```   
   
Agora já é possivel efetuar um attach nos discos, se os slices estiverem corretos vc vai cair nesse passo direto.
```console
bash-3.2# zpool attach -f rpool c0t361CEB4725D71723d0s0 c0t3B7CA031337740CDd0s0
    Make sure to wait until resilver is done before rebooting.
```

Verifique se deu tudo certo
```console
bash-3.2# zpool status
      pool: rpool
     state: ONLINE
    status: One or more devices is currently being resilvered.  The pool will
            continue to function, possibly in a degraded state.
    action: Wait for the resilver to complete.
     scan: resilver in progress since Mon Apr 16 12:49:37 2012
        3.46G scanned out of 6.54G at 111M/s, 0h0m to go
        3.46G scanned out of 6.54G at 111M/s, 0h0m to go
        3.46G resilvered, 52.95% done
    config:
    
            NAME                         STATE     READ WRITE CKSUM
            rpool                        ONLINE       0     0     0
              mirror-0                   ONLINE       0     0     0
                c0t361CEB4725D71723d0s0  ONLINE       0     0     0
                c0t3B7CA031337740CDd0s0  ONLINE       0     0     0  (resilvering)
    
    errors: No known data errors
```

Antes de continuar aguarde o "resilvering" dos disco.
```console
bash-3.2# zpool status
      pool: rpool
     state: ONLINE
    status: One or more devices is currently being resilvered.  The pool will
            continue to function, possibly in a degraded state.
    action: Wait for the resilver to complete.
     scan: resilver in progress since Mon Apr 16 12:49:37 2012
        6.50G scanned out of 6.54G at 63.4M/s, 0h0m to go
        6.50G scanned out of 6.54G at 63.4M/s, 0h0m to go
        6.50G resilvered, 99.36% done
    config:
    
            NAME                         STATE     READ WRITE CKSUM
            rpool                        ONLINE       0     0     0
              mirror-0                   ONLINE       0     0     0
                c0t361CEB4725D71723d0s0  ONLINE       0     0     0
                c0t3B7CA031337740CDd0s0  ONLINE       0     0     0  (resilvering)
    
    errors: No known data errors
```

Finalizado o "resilvering".
```console
bash-3.2# zpool status
      pool: rpool
     state: ONLINE
     scan: resilvered 6.54G in 0h1m with 0 errors on Mon Apr 16 12:51:23 2012
     config:
    
            NAME                         STATE     READ WRITE CKSUM
            rpool                        ONLINE       0     0     0
              mirror-0                   ONLINE       0     0     0
                c0t361CEB4725D71723d0s0  ONLINE       0     0     0
                c0t3B7CA031337740CDd0s0  ONLINE       0     0     0
    
    errors: No known data errors
```