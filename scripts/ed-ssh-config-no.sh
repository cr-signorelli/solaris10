#!/bin/sh

ed - << EOF
r /etc/ssh/sshd_config
/PermitRootLogin/
c
PermitRootLogin no
.
/X11Forwarding/
c
X11Forwarding no
.
w
q
EOF
