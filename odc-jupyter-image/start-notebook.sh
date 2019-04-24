#!/bin/rbash
set -e
echo "Change permissions to mounted efs user home to jovyan and the users group"
chown -R 1000:100 /home/jovyan
echo "Now starting the jupyterhub-singleuser notebook"
su jovyan --command "jupyterhub-singleuser --ip=\"*\""
su jovyan