# How to enable interface IPv6 on Solaris10-SPARC
---

**Server specification for this examples:**
- bge1 = physical network interface 
- 2001:db8:1:0:0:0:0:100/128 = interface ip address 
- 2001:db8:1:0:0:0:0:1 = default gateway 

---

**Enable the interface:**
```console
-bash-3.2# ifconfig inet6 <interface> plumb up
```
**Example:**
```sh
-bash-3.2# ifconfig inet6 bge1 plumb up
```
---
**Configure IP on interface:**
```console
-bash-3.2# ifconfig <interface> inet6 <address_ipv6>/<netmask> up
```
**Example:**
```console
-bash-3.2# ifconfig bge1 inet6 addif 2001:db8:1:0:0:0:0:100/128 up
```
---
**Adding a static route:**
```console
-bash-3.2# route -p add -inet6 default <gateway_ipv6>
```
**Example:**
```console
-bash-3.2# route -p add -inet6 default 2001:db8:1:0:0:0:0:1
```
---
**Adding the interface on system boot:**
```console
-bash-3.2# echo "addif <address_ipv6>/<netmask> up" > /etc/hostname6.<interface>
```
**Example:**
```console
-bash-3.2# echo "addif 2001:db8:1:0:0:0:0:100/128 up" > /etc/hostname6.bge1
```
---
**Adjust files permissions:**
```console
-bash-3.2# chmod 644 /etc/hostname.<interface>
```
**Example:**
```console
-bash-3.2# chmod 644 /etc/hostname.bge1
```
