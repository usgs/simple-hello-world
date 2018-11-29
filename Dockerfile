FROM python:3 AS testing

WORKDIR /usr/src/app

COPY docker-entrypoint.sh docker-entrypoint.sh
COPY gunicorn_config.py gunicorn_config.py
COPY healthcheck.py healthcheck.py
COPY requirements.txt requirements.txt
COPY hello application
RUN pip install --no-cache-dir -r requirements.txt
RUN python -m unittest
RUN rm -rf application/__pycache__/ && rm -rf application/tests


FROM usgswma/python:3.6
MAINTAINER Andrew Yan "ayan@usgs.gov"

WORKDIR /home/python

COPY --from=testing /usr/src/app/ ./

RUN [ "chmod", "+x", "docker-entrypoint.sh" ]
RUN chown python:python -R docker-entrypoint.sh gunicorn_config.py healthcheck.py application/
RUN pip install --no-cache-dir -r requirements.txt
ENV bind_ip 0.0.0.0
ENV bind_port 9050
ENV log_level INFO
EXPOSE ${bind_port}

USER python

HEALTHCHECK --interval=15s --timeout=15s --start-period=60s CMD python ./healthcheck.py
CMD ["./docker-entrypoint.sh"]
