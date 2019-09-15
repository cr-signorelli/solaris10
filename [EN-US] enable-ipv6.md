# How to enable interface IPv6 on Solaris10-SPARC
---

**Server specification for this examples**
- bge1 = physical network interface 
- 2001:db8:1:0:0:0:0:100/128 = interface ip address 
- 2001:db8:1:0:0:0:0:1 = default gateway 

---

**Enable the interface**
```console
-bash-3.2# ifconfig inet6 <interface> plumb up
```
**Example**
```sh
-bash-3.2# ifconfig inet6 bge1 plumb up
```

**Configure IP on interface**
```shellscript
-bash-3.2# ifconfig <interface> inet6 <endereco_ipv6>/<mascara> up
```
**Example**
```shellscript
-bash-3.2# ifconfig bge1 inet6 addif 2001:db8:1:0:0:0:0:100/128 up
```

**Adding a static route**
```shellscript
-bash-3.2# route -p add -inet6 default <gateway_ipv6>
```
**Example**
```shellscript
-bash-3.2# route -p add -inet6 default 2001:db8:1:0:0:0:0:1
```

**Adding the interface on system boot**
```shellscript
-bash-3.2# echo "addif <endereco_ipv6>/<mascara> up" > /etc/hostname6.<interface>
```
**Example**
```shellscript
-bash-3.2# echo "addif 2001:db8:1:0:0:0:0:100/128 up" > /etc/hostname6.bge1
```

**Adjust files permissions**
```shellscript
-bash-3.2# chmod 644 /etc/hostname.<interface>
```
**Example**
```shellscript
-bash-3.2# chmod 644 /etc/hostname.bge1
```
