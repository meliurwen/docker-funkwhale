#!/bin/sh

# Exit at first error
set -e

# Fill the varibles in funkwhale.template and put the result in default.conf
envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" <  \
         /etc/nginx/conf.d/funkwhale.template > \
         /etc/nginx/conf.d/default.conf

cat /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'
