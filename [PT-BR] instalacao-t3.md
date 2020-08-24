# Solaris 10 - Procedimento básico de instalação T3-1

---

**ILOM**

Configurando IP na NET-MGT.
```console
cd /SP/network 
set pendingipaddress=192.168.0.10
set pendingipnetmask=255.255.255.0  
set pendingipgateway=192.168.0.1
set commitpending=true
set state=enabled
```

Desativar o autoboot antes de ligar o sistema.
```console
-> set /HOST/bootmode script="setenv auto-boot? false"
-> start /SYS
```

Acesso o console
```console
-> start /HOST/console
```


**RAID via ILOM (apenas para T3.1 e T3.2)**

Verifica qual é a controladora SCSI.
```console
{0} ok probe-scsi-all
```

Selecione a controladora onde estão os disco.
```console
{0} ok select /pci@400/pci@1/pci@0/pci@4/scsi@0
```

Lista os disco e montando o raid.
```console
{0} ok show-children

FCode Version 1.00.54, MPT Version 2.00, Firmware Version 5.05.00.00
Target a
  Unit 0   Disk   HITACHI  H106030SDSUN300G A2B0    585937500 Blocks, 300 GB
  SASDeviceName 5000cca012b61364  SASAddress 5000cca012b61365  PhyNum 0
Target b
  Unit 0   Disk   HITACHI  H106030SDSUN300G A2B0    585937500 Blocks, 300 GB
  SASDeviceName 5000cca012b57114  SASAddress 5000cca012b57115  PhyNum 1
Target c
  Unit 0   Disk   HITACHI  H106030SDSUN300G A2B0    585937500 Blocks, 300 GB
  SASDeviceName 5000cca012b7564c  SASAddress 5000cca012b7564d  PhyNum 4
Target d
  Unit 0   Disk   HITACHI  H106030SDSUN300G A2B0    585937500 Blocks, 300 GB
  SASDeviceName 5000cca012b7cce0  SASAddress 5000cca012b7cce1  PhyNum 5
Target e
  Unit 0   Encl Serv device   SUN      SAS2 X16DBP      0305
  SASAddress 50800200000272bd  PhyNum 18

{0} ok a b  create-raid0-volume
Target a size is 583983104 Blocks, 298 GB
Target b size is 583983104 Blocks, 298 GB
The volume can be any size from 1 MB to 570296 MB
What size do you want?  [570296]
Volume size will be 1167966208 Blocks, 597 GB
Enter a volume name:  [0 to 15 characters] volume1
Volume has been created

{0} ok c d  create-raid0-volume
```

**Formatando os disco**

Usando o CD/DVD inicie a Solaris 10 em single mode.
```console
{0} ok boot cdrom -s
```

Use o comando format para identificar e começar a formatação.
```console
# format
    opção 0. Auto configuração
    quit
```

Use o comando abaixo para criar a label do disco.
```console
# format -e 
    Specify disk (enter its number): 0
    Disk not labeled.  Label it now? y
    format> label
    0
    enter =>y
    quit
```console

Refaça o procedimento para o outro volume também.

Após formartar e criar a label dos disco reinicie o sistema.
```console
# reboot
```

**Sistema operacional**

Caso o sistema operacional ainda não esteja instalado ao reiniciar voltamos ao menu inicial de instalação do Solaris 10.

**Espelhamento de disco usando o ZFS**

Apos a instalação e logado no sistema, faça o espelhamento dos disco/volumes.  

Use o comando abaixo para identificar os discos.
```console
ls /dev/rdsk/*s0
```

Identificando qual disco nosso sistema está instalado.
```console
zpool status
```

Criando o espelhamento
```console
zpool attach -f rpool c0t361CEB4725D71723d0s0 c0t3B7CA031337740CDd0s0
```

Para verificar o andamento do sincronismo use o comando de status novamente.
```console
zpool status
```

**Espelhamento de disco usando o ZFS com erro**

Lista a atual geometria do disco.
```console
prtvtoc /dev/dsk/c0t361CEB4725D71723d0s0  (2 discos tem que estar iguais)
```

Copie a saida para um arquivo.
```console
prtvtoc /dev/dsk/c0t361CEB4725D71723d0s0  > /tmp/vtoc_rpool.out
```

Aplique a configuração copiado no outro disco
```console
fmthard -s /tmp/vtoc_rpool.out /dev/rdsk/c0t3B7CA031337740CDd0s0
```

Crie o espelhamento
```console
zpool attach -f rpool c0t361CEB4725D71723d0s0 c0t3B7CA031337740CDd0s0
```

**Criando seu proprio dataset com quota**
```console
zfs create rpool/dados
zfs set mountpoint=/dados rpool/dados
zfs set quota=10G rpool/dados
zfs get quota rpool/dados
```

**Oracle Virtual Machine for SPARC - LDOM**

Configuração básica da virtualização.

**PRIMARY**

Verifique se o CDROM está colocado na máquina, vamos precisar dele para instalação das máquinas virtuais.
```console
df -lh
```

Configurando a primary.
```console
ldm add-vdiskserver primary-vds0 primary
ldm add-vdiskserverdevice -q /vol/dev/dsk/c1t6d0/sol_10_811_sparc cdrom@primary-vds0
ldm add-vdiskserverdevice -q /dev/zvol/rdsk/rpool/primary vol0@primary-vds0
ldm add-vconscon port-range=5000-5005 primary-vcc0 primary
ldm add-vswitch net-dev=igb0 primary-vsw0 primary
ldm set-mau 1 primary
ldm set-vcpu 24 primary
ldm set-memory 7G primary
svcadm enable vntsd
ldm add-config config_initial
touch /reconfigure
```

Configurando LDOM1
```console
ldm add-vswitch net-dev=nxge0 primary-vsw1 primary
ldm add-vdiskserver primary-vds1 primary
zfs create -V 125G rpool/ldom1
ldm add-vdiskserverdevice /dev/zvol/rdsk/rpool/ldom1 vol1@primary-vds1
ldm add-domain ldom1
ldm set-vcpu 26 ldom1
ldm set-memory 14G ldom1
ldm add-vnet vnet0 primary-vsw1 ldom1
ldm add-vdisk vdisk1 vol1@primary-vds1 ldom1
ldm set-variable auto-boot/?=false ldom1
ldm set-variable boot-device=vdisk1 ldom1
ldm set-vcons port=5000 group=SP service=primary-vcc0 ldom1
ldm add-vdisk cdrom cdrom@primary-vds0 ldom1
ldm bind-domain -q ldom1
ldm start-domain ldom1
```

Configurando LDOM2
```console
ldm add-vswitch net-dev=nxge1 primary-vsw2 primary
ldm add-vdiskserver primary-vds2 primary
zfs create -V 125G rpool/ldom2
ldm add-vdiskserverdevice /dev/zvol/rdsk/rpool/ldom2 vol2@primary-vds2
ldm add-domain ldom2
ldm set-vcpu 26 ldom2
ldm set-memory 14G ldom2
ldm add-vnet vnet0 primary-vsw2 ldom2
ldm add-vdisk vdisk2 vol2@primary-vds2 ldom2
ldm set-variable auto-boot/?=false ldom2
ldm set-variable boot-device=vdisk2 ldom2
ldm set-vcons port=5000 group=SP service=primary-vcc0 ldom2
ldm remove-vdisk cdrom ldom1
ldm add-vdisk cdrom cdrom@primary-vds0 ldom2
ldm bind-domain -q ldom2
ldm start-domain ldom2
```

Configurando LDOM3
```console
ldm add-vswitch net-dev=nxge2 primary-vsw3 primary
ldm add-vdiskserver primary-vds3 primary
zfs create -V 125G rpool/ldom3
ldm add-vdiskserverdevice /dev/zvol/rdsk/rpool/ldom3 vol3@primary-vds3
ldm add-domain ldom3
ldm set-vcpu 26 ldom3
ldm set-memory 14G ldom3
ldm add-vnet vnet0 primary-vsw3 ldom3
ldm add-vdisk vdisk3 vol3@primary-vds3 ldom3
ldm set-variable auto-boot/?=false ldom3
ldm set-variable boot-device=vdisk3 ldom3
ldm set-vcons port=5000 group=SP service=primary-vcc0 ldom3
ldm remove-vdisk cdrom ldom2
ldm add-vdisk cdrom cdrom@primary-vds0 ldom3
ldm bind-domain -q ldom3
ldm start-domain ldom3
```

Configurando LDOM4
```
ldm add-vswitch net-dev=nxge3 primary-vsw4 primary
ldm add-vdiskserver primary-vds4 primary
zfs create -V 125G rpool/ldom4
ldm add-vdiskserverdevice /dev/zvol/rdsk/rpool/ldom4 vol4@primary-vds4
ldm add-domain ldom4
ldm set-vcpu 26 ldom4
ldm set-memory 14G ldom4
ldm add-vnet vnet0 primary-vsw4 ldom4
ldm add-vdisk vdisk4 vol4@primary-vds4 ldom4
ldm set-variable auto-boot/?=false ldom4
ldm set-variable boot-device=vdisk4 ldom4
ldm set-vcons port=5000 group=SP service=primary-vcc0 ldom4
ldm remove-vdisk cdrom ldom3
ldm add-vdisk cdrom cdrom@primary-vds0 ldom4
ldm bind-domain -q ldom4
ldm start-domain ldom4
```