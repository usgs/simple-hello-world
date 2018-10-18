#!/usr/bin/env bash

gunicorn --reload application.app --config file:$HOME/gunicorn_config.py
