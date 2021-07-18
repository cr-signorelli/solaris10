# Solaris 10 - How to install SSH clients

---

**Requiriments**
- Solaris 10 image ISO

---

Mount ISO image.
```console
lofiadm -a /dados/install-src/sol-10-u11-ga-sparc-dvd.iso
mount -F hsfs -o ro /dev/lofi/1 /mnt
```

Access the directory.
```console
cd /mnt/cd Solaris_10/Product
```

Package necessary
```
SUNWsshr   SSH Client and utilities, (Root)
SUNWsshu   SSH Client and utilities, (Usr)
```

Install package.
```console
pkgadd -d . SUNWsshu
```

Check the packages installed.
```console
-bash-3.2# pkginfo | grep ssh
```