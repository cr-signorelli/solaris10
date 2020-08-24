# ALOM - How to configure IP address

---

**It is possible to use in equipments like SunFire V100, T1000, T2000, and T5120.**

---

First step, disable DHCP.
```console
sc> setsc netsc_dhcp false
```

After disable DHCP configure IP address.
```console
sc> setsc netsc_ipaddr 192.0.2.10
sc> setsc netsc_ipnetmask 255.255.255.0
sc> setsc netsc_ipgateway 192.0.2.1
```