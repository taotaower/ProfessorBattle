#!/bin/bash

export PORT=5101

cd ~/www/profbattle
./bin/profbattle stop || true
./bin/profbattle start

