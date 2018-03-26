#!/bin/bash

export PORT=5105
export MIX_ENV=prod
export GIT_PATH=/home/profbattle/src/profbattle 

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "profbattle" ]; then
	echo "Error: must run as user 'profbattle'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/profbattle ]; then
	echo mv ~/www/profbattle ~/old/$NOW
	mv ~/www/profbattle ~/old/$NOW
fi

mkdir -p ~/www/profbattle
REL_TAR=~/src/profbattle/_build/prod/rel/profbattle/releases/0.0.1/profbattle.tar.gz
(cd ~/www/profbattle && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/profbattle/src/profbattle/start.sh
CRONTAB

#. start.sh
