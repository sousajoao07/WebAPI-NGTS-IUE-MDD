FROM postgres:14.1-alpine

USER root

RUN apk --no-cache add \
  sudo            \
  nano            \
  bash            \
  && rm -rf /var/cache/apk/* /tmp/*

RUN echo "postgres ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY ./postgres/entrypoint.sh /usr/local/bin/entrypoint

RUN chmod 755 /usr/local/bin/entrypoint

USER postgres

WORKDIR /home

EXPOSE 5432

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]

CMD [ "postgres" ]
