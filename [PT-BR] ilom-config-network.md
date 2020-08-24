# ILOM - configurando IP address na NET-MGT

---

Uma vez logado na console da ILOM use os comandos abaixo para configurar a rede.
```console
> cd /SP/network
> set pendingipaddress=192.0.2.10
> set pendingipnetmask=255.255.255.0 
> set pendingipgateway=192.0.2.1
> set commitpending=true
```