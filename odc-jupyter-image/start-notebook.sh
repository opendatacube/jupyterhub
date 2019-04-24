#!/bin/rbash
set -e
echo "Now starting the jupyterhub-singleuser notebook"
su jovyan --command "jupyterhub-singleuser --ip=\"*\""
su jovyan