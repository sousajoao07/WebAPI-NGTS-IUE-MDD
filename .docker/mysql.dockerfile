FROM mysql/mysql-server:8.0

USER root

RUN microdnf install -y sudo nano \
  && microdnf clean all

RUN cp -ar /etc/skel /home/mysql \
  && echo "mysql ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY ./mysql/entrypoint.sh /usr/local/bin/entrypoint
COPY ./mysql/my.cnf /etc/mysql/my.cnf

RUN chmod 755 /usr/local/bin/entrypoint

RUN chown -R mysql:mysql /home/mysql && chmod 700 /home/mysql
  
USER mysql

WORKDIR /home/mysql

EXPOSE 3306 33060 33061

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]

CMD [ "mysqld" ]
