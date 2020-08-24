# DNS Bind9 - desligando e reiniciando serviço

**Bind 9.8.x / 9.9.x / 9.10.x / 9.11.x**

Consolidar os arquivos journal (.jnl) nos arquivos de zona (.zone) – Este comando pode demorar:
```console
-bash-3.2# /usr/local/sbin/rndc freeze
-bash-3.2# /usr/local/sbin/rndc sync –clean
```

Parar o serviço BIND:
```console
-bash-3.2# /usr/local/sbin/rndc stop
```

Confirmar se o serviço foi finalizado com sucesso. Nada deve ser retornado:
```console
-bash-3.2# ps -f | grep named | grep -v grep
```

Reiniciando o serviço "-n 5" representa o número de processadores que serão usados pelo DNS
```console
-bash-3.2# /usr/local/sbin/named -n 2
```
