FROM python:3 AS testing

WORKDIR /usr/src/app

COPY docker-entrypoint.sh docker-entrypoint.sh
COPY gunicorn_config.py gunicorn_config.py
COPY requirements.txt requirements.txt
COPY hello application
RUN pip install --no-cache-dir -r requirements.txt
RUN python -m unittest
RUN rm -rf application/__pycache__/ && rm -rf application/tests


FROM alpine:3.8
MAINTAINER Andrew Yan "ayan@usgs.gov"

ENV USER=python
ENV HOME=/home/$USER
ENV PATH="$PATH:$HOME/.local/bin"

ARG ssl_keyfile
ARG ssl_certfile
RUN apk update && apk upgrade
RUN apk add --update --no-cache \
  python3 \
  python3-dev \
  build-base \
  ca-certificates \
  curl \
  openssl \
  bash
RUN pip3 install --upgrade pip
RUN adduser --disabled-password -u 1000 $USER
WORKDIR $HOME

COPY --from=testing /usr/src/app/ ./

RUN [ "chmod", "+x", "docker-entrypoint.sh" ]
RUN chown $USER:$USER docker-entrypoint.sh gunicorn_config.py && chown -R $USER:$USER $HOME
USER $USER
RUN pip3 install --user -r requirements.txt
ENV bind_ip 0.0.0.0
ENV bind_port 9050
ENV ssl_keyfile ${ssl_keyfile}
ENV ssl_certfile ${ssl_certfile}
ENV log_level INFO
EXPOSE ${bind_port}

HEALTHCHECK CMD curl --fail http://127.0.0.1:${bind_port}/hi/hello-world || exit 1
CMD ["./docker-entrypoint.sh"]
