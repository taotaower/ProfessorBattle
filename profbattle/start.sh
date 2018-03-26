#!/bin/bash

export PORT=5105

cd ~/www/profbattle
./bin/profbattle stop || true
./bin/profbattle start

