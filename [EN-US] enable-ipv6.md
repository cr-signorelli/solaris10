# How to enable interface IPv6 on Solaris10-SPARC
---

**Server specification for this examples**
- bge1 = physical network interface 
- 2001:db8:1:0:0:0:0:100/128 = interface ip address 
- 2001:db8:1:0:0:0:0:1 = default gateway 

---

**Enable the interface**
```shellscript
ifconfig inet6 <interface> plumb up
```
**Example**
```shellscript
ifconfig inet6 bge1 plumb up
```

**Configure IP on interface**
```shellscript
ifconfig <interface> inet6 <endereco_ipv6>/<mascara> up
```
**Example**
```shellscript
ifconfig bge1 inet6 addif 2001:db8:1:0:0:0:0:100/128 up
```

**Adding a static route**
```shellscript
route -p add -inet6 default <gateway_ipv6>
```
**Example**
```shellscript
route -p add -inet6 default 2001:db8:1:0:0:0:0:1
```

**Adding the interface on system boot**
```shellscript
echo "addif <endereco_ipv6>/<mascara> up" > /etc/hostname6.<interface>
```
**Example**
```shellscript
echo "addif 2001:db8:1:0:0:0:0:100/128 up" > /etc/hostname6.bge1
```

**Adjust files permissions**
```shellscript
chmod 644 /etc/hostname.<interface>
```
**Example**
```shellscript
chmod 644 /etc/hostname.bge1
```
