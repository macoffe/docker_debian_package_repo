FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y apache2 reprepro gnupg inotify-tools\
    && apt-get autoclean \
    && apt-get autoremove


ADD .config /conf
ADD scripts /

EXPOSE 80
ENTRYPOINT ["/startup.sh"]
