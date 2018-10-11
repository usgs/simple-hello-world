FROM alpine:3.8
MAINTAINER Andrew Yan "ayan@usgs.gov"
ARG artifact_version
ARG ssl_keyfile
ARG ssl_certfile
ARG build_type
ARG listening_port=9050
RUN apk update && apk upgrade && mkdir /local
RUN apk add --update \
  python3 \
  python3-dev \
  build-base \
  ca-certificates \
  curl \
  openssl \
  bash
RUN update-ca-certificates
COPY gunicorn_config.py /local/gunicorn_config.py
COPY requirements.txt /requirements.txt
COPY my_app /application
COPY docker-entrypoint.sh /usr/local/bin/
RUN export PIP_CERT="/etc/ssl/certs/ca-certificates.crt" && \
    pip3 install --upgrade pip && \
    pip3 install -r /requirements.txt
ENV bind_ip 0.0.0.0
ENV bind_port ${listening_port}
ENV ssl_keyfile ${ssl_keyfile}
ENV ssl_certfile ${ssl_certfile}
ENV log_level INFO
EXPOSE ${bind_port}
HEALTHCHECK CMD curl -k http://127.0.0.1/${listening_port}/hi/hello-world | grep -q "\"greeting\" : \"Hi!\"" || exit 1
CMD ["docker-entrypoint.sh"]
