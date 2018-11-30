#!/usr/bin/env bash

gunicorn application.app --config file:$HOME/gunicorn_config.py
