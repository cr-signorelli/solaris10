# How to create .pkg for Solaris 10

---

Creating Solaris Packages.
- <a href="https://www.ibiblio.org/pub/packages/solaris/i86pc/html/creating.solaris.packages.html" target="_blank">`https://www.ibiblio.org/pub/packages/solaris/i86pc/html/creating.solaris.packages.html`</a>


Load the image on system.
```console
-bash-3.2#  lofiadm -a /tmp/sol-10-u11-ga-sparc-dvd.iso 
```

Mount the virtual device.
```console
-bash-3.2# mount -F hsfs -o ro /dev/lofi/1 /mnt
```

Enter directory.
```console
-bash-3.2# cd /mnt/Solaris_10/
```

Create a package using the archives based on the image (ISO).
```console
-bash-3.2# pkgtrans -s Product /var/tmp/ssh-client.pkg SUNWsshu
```

Testing the package created.
```console
-bash-3.2# cd /var/tmp/
-bash-3.2# pkgadd -d ./ssh-client.pkg
```