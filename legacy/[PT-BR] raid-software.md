# Solaris 10 - RAID via software

---

**It is possible to use in equipments like SunFire V100, T1000, T2000, and T5120.**

---

Alguns servidores não possuem gerenciamento da controladora SCSI. Para montar o RAID nos HDs use o CD/DVD do Solaris (versão usada Solaris 10).  

Acesse a ILOM da máquina via console (é possivel acessar por SSH, mas a NET-MGT deve estar configurada) 
```console
login as: root
    Using keyboard-interactive authentication.
    Password:
    Waiting for daemons to initialize...

    Daemons ready
    Oracle(R) Integrated Lights Out Manager
    Version 3.0.12.4 r59946
    Copyright (c) 2010, Oracle and/or its affiliates. All rights reserved.

-> start /SYS

-> start /HOST/console
    Are you sure you want to start /HOST/console (y/n)? y
    Serial console started.  To stop, type #.

{0} ok boot cdrom -s

    Boot device: /pci@0/pci@0/pci@1/pci@0/pci@1/pci@0/usb@0,2/hub@4/device@4/storage@0/disk@0:f  File and args: -s
    SunOS Release 5.10 Version Generic_147440-01 64-bit
    Copyright (c) 1983, 2011, Oracle and/or its affiliates. All rights reserved.
    Booting to milestone "milestone/single-user:default".
    Configuring devices.
    Using RPC Bootparams for network configuration information.
    Attempting to configure interface nxge3...
    NOTICE: nxge2: xcvr addr:0x0b - link is down
    NOTICE: nxge0: xcvr addr:0x0d - link is down
    NOTICE: nxge3: xcvr addr:0x0a - link is down
    NOTICE: nxge1: xcvr addr:0x0c - link is down
    Skipped interface nxge3
    Attempting to configure interface nxge2...
    Skipped interface nxge2
    Attempting to configure interface nxge1...
    Skipped interface nxge1
    Attempting to configure interface nxge0...
    Skipped interface nxge0
    Attempting to configure interface e1000g3...
    Skipped interface e1000g3
    Attempting to configure interface e1000g2...
    Skipped interface e1000g2
    Attempting to configure interface e1000g1...
    Skipped interface e1000g1
    Attempting to configure interface e1000g0...
    Skipped interface e1000g0
    Requesting System Maintenance Mode
    SINGLE USER MODE
```

Use o comando format para saber quais são os disco do equipamento e apos identicar quais são os discos interrompa o processo com CTRL+C

```console
# format
    Searching for disks...done

    AVAILABLE DISK SELECTIONS:
           0. c1t0d0 <SUN300G cyl 46873 alt 2 hd 20 sec 625>
              /pci@0/pci@0/pci@2/scsi@0/sd@0,0
           1. c1t1d0 <SUN300G cyl 46873 alt 2 hd 20 sec 625>
              /pci@0/pci@0/pci@2/scsi@0/sd@1,0
    Specify disk (enter its number):
```

Nessa caso especifico a máquina possue apenas 2 discos.  


Então vamos fazer RAID1 (espelhamento) do disco 1 para o 2
```console
# raidctl -c -r 1 c1t0d0 c1t1d0
    Creating RAID volume will destroy all data on spare space of member disks, proceed (yes/no)? yes
    /pci@0/pci@0/pci@2/scsi@0 (mpt0):
            Physical disk 0 created.
    /pci@0/pci@0/pci@2/scsi@0 (mpt0):
            Physical disk 1 created.
    /pci@0/pci@0/pci@2/scsi@0 (mpt0):
            Volume 0 created.
    WARNING: /pci@0/pci@0/pci@2/scsi@0 (mpt0):
            Volume 0 is degraded
    
    /pci@0/pci@0/pci@2/scsi@0 (mpt0):
            Physical disk (target 1) is |out of sync||online|
    /pci@0/pci@0/pci@2/scsi@0 (mpt0):
            Volume 0 is |enabled||degraded|
    /pci@0/pci@0/pci@2/scsi@0 (mpt0):
            Volume 0 is |enabled||resyncing||degraded|
    WARNING: /pci@0/pci@0/pci@2/scsi@0/sd@0,0 (sd4):
            Corrupt label - bad geometry
    
            Label says 585925000 blocks; Drive says 585805824 blocks
    WARNING: /pci@0/pci@0/pci@2/scsi@0/sd@0,0 (sd4):
            Corrupt label - bad geometry
    
            Label says 585925000 blocks; Drive says 585805824 blocks
    Volume c1t0d0 is created successfully!
```

Verifique se o RAID1 foi criado corretamente.
```console
# raidctl -l
Controller: 1
        Volume:c1t0d0
        Disk: 0.0.0
        Disk: 0.1.0
```

Agora inicie o processo de formatação do disco.
```console
# format -e
    Searching for disks...WARNING: /pci@0/pci@0/pci@2/scsi@0/sd@0,0 (sd4):
            Corrupt label - bad geometry
    
            Label says 585925000 blocks; Drive says 585805824 blocks
    WARNING: /pci@0/pci@0/pci@2/scsi@0/sd@0,0 (sd4):
            Corrupt label - bad geometry
    
            Label says 585925000 blocks; Drive says 585805824 blocks
    done
    
    c1t0d0: configured with capacity of 278.99GB
    
    AVAILABLE DISK SELECTIONS:
           0. c1t0d0 <LSILOGIC-LogicalVolume-3000 cyl 65533 alt 2 hd 32 sec 279>
              /pci@0/pci@0/pci@2/scsi@0/sd@0,0
    Specify disk (enter its number): 0
    selecting c1t0d0
    [disk formatted]
    WARNING: /pci@0/pci@0/pci@2/scsi@0/sd@0,0 (sd4):
            Corrupt label - bad geometry
    
    Disk not labeled.  Label it now?        Label says 585925000 blocks; Drive says 585805824 blocks
    yes
    
    WARNING: /pci@0/pci@0/pci@2/scsi@0/sd@0,0 (sd4):
            Corrupt label - bad geometry
    
            Label says 585925000 blocks; Drive says 585805824 blocks
    WARNING: /pci@0/pci@0/pci@2/scsi@0/sd@0,0 (sd4):
            Corrupt label - bad geometry
    
            Label says 585925000 blocks; Drive says 585805824 blocks
    
    FORMAT MENU:
            disk       - select a disk
            type       - select (define) a disk type
            partition  - select (define) a partition table
            current    - describe the current disk
            format     - format and analyze the disk
            repair     - repair a defective sector
            label      - write label to the disk
            analyze    - surface analysis
            defect     - defect list management
            backup     - search for backup labels
            verify     - read and display labels
            save       - save new disk/partition definitions
            inquiry    - show vendor, product and revision
            scsi       - independent SCSI mode selects
            cache      - enable, disable or query SCSI disk cache
            volname    - set 8-character volume name
            !<cmd>     - execute <cmd>, then return
            quit
```

O padrão de LABEL que devemos usar é SM, mas devido a um BUG devemos alterar para EFI e voltar.

```console
    format> label
    [0] SMI Label
    [1] EFI Label
    Specify Label type[0]: 1
    Warning: This disk has an SMI label. Changing to EFI label will erase all
    current partitions.
    Continue? yes
    
    format> label
    [0] SMI Label
    [1] EFI Label
    Specify Label type[1]: 0
    Auto configuration via format.dat[no]? y
    
    Geometry: 32 heads, 279 sectors 65535 cylinders result in 585096480 out of 585805824 blocks.
    Do you want to modify the device geometry[no]?
    format> quit
```

Após finalizar o RAID e a formatação reinicie o servidor.
```console
# reboot
    syncing file systems... done
    rebooting...
    Resetting...
```

Apos reiniciar, já é possivel montar os disco em um sistema pré existente ou instalar um novo.