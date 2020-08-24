# Criando usuário e gerando as chaves de cryptografia

---

Cria o usuario com grupo, diretório e shell especifico:
```console
-bash-3.2# useradd -c teste -g other -d "/export/home/teste" -m -s "/usr/bin/bash" teste
```

Criando o diretório para armazenar a chave:
```console
-bash-3.2# mkdir /export/home/teste/.ssh
```

Gerando a chave:
```console
-bash-3.2# ssh-keygen -t rsa -b 2048 -q -C "acesso basico" -N "senha-da-chave-de-seguranca" -f /export/home/teste/.ssh/id_rsa
```

Detalhamento do comando:

|                                   |                                                                    |
|-----------------------------------|--------------------------------------------------------------------|
| ssh-keygen                        | comando                                                            |
| -t rsa                            | dsa | ecdsa | ed25519 | rsa | rsa1 - tipo da chave que será criada |
| -b 2048                           | bits da chave                                                      |
| -q                                | modo silencioso, ou seja, não pede confirmação de nada             |
| -C "acesso basico"                | comentários                                                        |
| -N "senha-da-chave-de-seguranca"  | passphrase ( frase / senha que será utilizada )                    |
| -f /export/home/teste/.ssh/id_rsa | nome do arquivo que será usado para armazenar a chave criada.      |
