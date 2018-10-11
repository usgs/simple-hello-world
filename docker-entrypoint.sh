#!/usr/bin/env bash

/usr/bin/gunicorn --chdir / --reload application.app --config file:/local/gunicorn_config.py
