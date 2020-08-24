# Solaris 10 - Montando HD externo ( sem file system )

---

For�e o SO a procurar novos devices USB
```console
iostat -En
```

Verifique qual � o drive externo:
```console
rmformat -l
```

Crie uma parti��o prim�ria
```console
fdisk /dev/rdsk/c3t0d0p0
```

Verifique a quantidade de setores
```console
prtvtoc /dev/rdsk/c3t0d0p0
```

Crie o file system ( esse procedimento apaga todos os dados )
```console
newfs -v -b 8192 -i 16384 -s 3906745920 /dev/rdsk/c3t0d0p0
```

Montando o file system em um diret�rio
```console
mount /dev/dsk/c3t0d0s2 /opt/iomega
```

Montando o disco como volume l�gico ( ZFS )
```console
zpool create -R /opt/iomega -f iomega /dev/dsk/c3t0d0
```

Ativando compress�o do disco ( isso afeta a performance )
```console
zfs set compression=on iomega
```