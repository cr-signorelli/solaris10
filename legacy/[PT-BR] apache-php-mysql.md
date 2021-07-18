# Solaris 10 - Apache / PHP / MySQL

---

Garantir que existe no PATH no mínimo:
```console
-bash-3.2# PATH=/usr/bin:/usr/sbin:/usr/ccs/bin:/usr/local/bin:/usr/sfw/bin/
```

Apache - httpd-2.2.17
```console
-bash-3.2# gunzip -c httpd-2.2.17.tar.gz | tar xf -
-bash-3.2# cd httpd-2.2.17
-bash-3.2# ./configure --enable-ldap --enable-authnz-ldap --with-ldap --enable-so

MYSQL - mysql-5.1.40
```console
-bash-3.2# gunzip -c mysql-5.1.40.tar.gz | tar xf -
-bash-3.2# cd mysql-5.1.40
-bash-3.2# ./configure --prefix=/usr/local/mysql --enable-assembler --with-innodb

PHP - php-5.2.14
```console
-bash-3.2# gunzip -c php-5.2.14.tar.gz | tar xf -
-bash-3.2# cd php-5.2.14
-bash-3.2# ./configure --with-mysql=/usr/local/mysql/ --with-apxs2=/usr/local/apache2/bin/apxs --with-ldap --with-iconv-dir=/usr/local/lib --with-libxml-dir=/usr/local/lib

Caso tenha problema na libxml na compilação do PHP é necessário:
* pkgrm SMClxml2
* executar o configure e o make
* compilar a libxml (libxml2-2.7.8.tar.gz)
* executar o make install