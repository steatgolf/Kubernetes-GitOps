#!/bin/bash

# Fail on error and undefined variables
set -euo pipefail


# Update and upgrade the system packages
kubectl apply -f 1-namespace.yaml
kubectl apply -f .
