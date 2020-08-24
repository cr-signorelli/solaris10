# LDAP SunOS 5.6 start / stop service

**Check if the service was running or not:**
```console
-bash-3.2# ps -ef | grep mps
```

**Expected outcome:**
```console
   root  1722     1   0   Mar 26 ?           0:43 ./uxwdog -e -d /opt/iplanet/mps/admin-serv/config
   root   515     1   0   Mar 23 ?        8075:12 ./ns-slapd -D /opt/iplanet/mps/slapd-`hostname` -i /opt/iplanet/mps/slapd
```

----

**How to start service:**
```console
-bash-3.2# /opt/iplanet/mps/slapd-`hostname`/start-slapd
```

**How to stop service:**
```console
-bash-3.2# /opt/iplanet/mps/slapd-`hostname`/stop-slapd
```

----

**How to start service to access by client:**
```console
-bash-3.2# /opt/iplanet/mps/start-admin
```

**How to stop service to access by client:**
```console
-bash-3.2# /opt/iplanet/mps/stop-admin
```

----

**Check the logs files:**
```console
-bash-3.2# tail -f /opt/iplanet/mps/slapd-`hostname`/logs/errors
-bash-3.2# tail -f /opt/iplanet/mps/slapd-`hostname`/logs/access
```