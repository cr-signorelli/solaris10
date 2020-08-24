# DNS Bind9 - extraindo conteúdo de uma arquivo RAW

---

**Como abrir o conteúdo de um arquivo de zone em formato RAW**

```console
/usr/local/sbin/named-compilezone -f raw -F text -o arquivo.txt dominio.com.br. dominio.com.br.zone
```

Detalhamento do comando:  

|                                   |                                           |
|-----------------------------------|-------------------------------------------|
| /usr/local/sbin/named-compilezone | comando                                   |
| -f raw -F text                    | formato de raw para txt                   |
| -o                                | saída                                     |
| arquivo.txt                       | arquivo texto                             |
| dominio.com.br.                   | dominio                                   |
| dominio.com.br.zone2              | arquivo de zona com o conteudo do dominio |   


**Como converter um arquivo de TXT para RAW:**

```console
/usr/local/sbin/named-compilezone -f text -F raw -o dominio.com.br.zone dominio.com.br arquivo.txt
```