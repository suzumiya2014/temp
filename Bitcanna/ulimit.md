FIlE LIMIT TO Make Node Strong

Just a heads up if anyone is struggling with increasing ulimit

Ideally you shouldnt be using root user, but if you are running all the services on root

then you have to add

```shell
sudo su -c "echo 'root hard nofile 94000' >> /etc/security/limits.conf"
sudo su -c "echo 'root soft nofile 94000' >> /etc/security/limits.conf"

```

the * in the commands

```shell
sudo su -c "echo '* hard nofile 94000' >> /etc/security/limits.conf"
sudo su -c "echo '* soft nofile 94000' >> /etc/security/limits.conf"

```

enables it for every other user except for root

in case of root you have replace * with root
