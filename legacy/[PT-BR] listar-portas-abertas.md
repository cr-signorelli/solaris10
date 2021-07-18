# Solaris - Listar portas abertas

---

Comando para listar as portas abertas.
```console
-bash-3.2#  cd /proc ; /usr/proc/bin/pfiles * | egrep "^[0-9]|sockname" | more 
```

O comando acima mostrara uma lista de portas em uso. A partir disso voce tera algo como:
```console
2287: /usr/sfw/sbin/snmpd
sockname: AF_INET 0.0.0.0 port: 161
sockname: AF_INET 0.0.0.0 port: 33543
sockname: AF_INET 0.0.0.0 port: 0
```

Veja que o numero 2287 que esta a esquerda é o número do processo que está usando a porta 161.

```console
-bash-3.2# ps -ef|grep 2287
root 2287 1 0 Oct 10 ? 0:16 /usr/sfw/sbin/snmpd
```

Se parar esse processo deve-se poder reiniciar o serviço de SMA. Sugiro que aguarde uns 10 minutos para ver se o processo init não o reinicia sozinho. De todos modos o arquivo citado acima /etc/rc2.d/S31snmp deve ser movido de onde está, pois o serviço de SMF tem o registro para o serviço de SMA.