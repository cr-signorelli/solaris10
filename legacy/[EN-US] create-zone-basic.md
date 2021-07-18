# How to create a zone on Solaris10

---

Create a directory.
```console
-bash-3.2# mkdir -p /export/zones
```

---

Ajust permission.
```console
-bash-3.2# chmod -R 700 /export/zones
```

---

Start zone creation.
```console
-bash-3.2# zonecfg -z zone1
```

---

Inside do console zone configuration.
```bash
create
set zonepath=/export/zones
set autoboot=true
set bootargs="-m verbose"
add dedicated-cpu    
set ncpus=1
end
set limitpriv="default,sys_time"
set scheduling-class=FSS
remove inherit-pkg-dir dir=/lib
remove inherit-pkg-dir dir=/platform
remove inherit-pkg-dir dir=/sbin
remove inherit-pkg-dir dir=/usr
add net
set address=192.0.2.231
set physical=vnet0
set defrouter=192.0.2.1
end
verify
commit
exit
```

---

List the zones created on your server.
```console
-bash-3.2# zoneadm list -cv
```

---

Start the installation.
```console
-bash-3.2# zoneadm -z zone1 install 
```

---

After the install start/boot the zone.
```console
-bash-3.2# zoneadm -z zone1 boot 
```

---

User this command to access the zone in console mode.
```console
-bash-3.2# zlogin -C zone1
```

---

Once inside the zone type "~." to escape do zlogin -C