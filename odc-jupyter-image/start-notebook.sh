#!/bin/rbash
set -e
echo "Now starting the jupyterhub-singleuser notebook"
jupyterhub-singleuser --ip=\"*\"