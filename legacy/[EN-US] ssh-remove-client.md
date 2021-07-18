# How to remove SSH clients from the servers

---

Find the correct packages to remove first.
```console
-bash-3.2# pkginfo | grep ssh
```

Expected outcome.
```console
system      SUNWsshcu                    SSH Common, (Usr)
system      SUNWsshdr                    SSH Server, (Root)
system      SUNWsshdu                    SSH Server, (Usr)
system      SUNWsshr                     SSH Client and utilities, (Root)
system      SUNWsshu                     SSH Client and utilities, (Usr)
```

After identifying the packages, use this command to remove them.
```console
-bash-3.2# pkgrm -n SUNWsshr SUNWsshu
```