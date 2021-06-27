#!/usr/bin/env bash

mkdocs build
cp -a ./site/. /var/www/html
