# Solaris 10 - Recuperando / Reset da senha de root

---

Através da ILOM acesse "prompt ok" via console e faça o boot pelo CD/DVD ou RCDROM.
```console
{0} ok boot -F failsafe
```

```console
mount /dev/dsk/c0t3d0s0 /a
cd /a/etc
TERM=vt100
export TERM
vi /a/etc/shadow
```

Exemplo de uma linha com a senha.
```console
root:$5$QfObWpuZ$J7G8MgJmXoNm35l1oGHw1j138gBKzzK20UtME.qhPNB:15923::::::22624
```

Exemplo de uma linha sem a senha.
```console
root::15923::::::22624
```

Apos remover a hash da senha, desmonte o disco e reinicie o sistema.
```console
cd /
umount /a
init 6
```