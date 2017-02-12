#!/bin/bash

find $(dirname "$0") -maxdepth 1 -type d ! -path $(dirname "$0") | xargs -I {} bash -c 'cd {} && echo "*** {} ***" && git pull'
