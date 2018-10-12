#!/usr/bin/env bash

gunicorn --reload application.app --config file:$HOME/local/gunicorn_config.py
