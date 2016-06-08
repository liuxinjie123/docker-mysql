FROM ubuntu-1404
MAINTAINER hary <dwj_zz@163.com>

# 添加文件夹下的 MYSQL 配置文件
ADD my.cnf             /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# 添加 MYSQL 的脚本
ADD run.sh    /run.sh
RUN chmod 755 /*.sh

# 设置环境变量，用户名以及秘密
ENV MYSQL_USER **Random**
ENV MYSQL_PASS **Random**

# 设置主从复制模式下的环境变量
ENV REPLICATION_MASTER **False**
ENV REPLICATION_SLAVE **False**
ENV REPLICATION_USER replica
ENV REPLICATION_PASS replica

# 设置可以允许挂载的卷，可以用来备份数据库和配置文件
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/migration" ]

WORKDIR /migration

# 设置可以映射的端口，如果是从我们的 sshd 镜像继承的话，默认还会开启 22 端口
EXPOSE 3306
CMD ["/run.sh"]

