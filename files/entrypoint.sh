#!/usr/bin/env bash

umask 022

#do a string replace for configuration files for the web root. 
if [[ "${REDIS_DB}" != "" ]]; then
    sed -i "s#%%REDIS_DB%%#${REDIS_DB}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%REDIS_DB%%#${REDIS_DB}#" /usr/local/learninglocker/current/xapi/.env
else
    #set a default if one is not present
    REDIS_DB="0"
    sed -i "s#%%REDIS_DB%%#${REDIS_DB}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%REDIS_DB%%#${REDIS_DB}#" /usr/local/learninglocker/current/xapi/.env
fi

#do a string replace for configuration files for the web root. 
if [[ "${REDIS_HOST}" != "" ]]; then
    sed -i "s#%%REDIS_HOST%%#${REDIS_HOST}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%REDIS_HOST%%#${REDIS_HOST}#" /usr/local/learninglocker/current/xapi/.env
else
    #set a default if one is not present
    REDIS_HOST="127.0.0.1"
    sed -i "s#%%REDIS_HOST%%#${REDIS_HOST}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%REDIS_HOST%%#${REDIS_HOST}#" /usr/local/learninglocker/current/xapi/.env
fi

#do a string replace for configuration files for the web root. 
if [[ "${REDIS_PORT}" != "" ]]; then
    sed -i "s#%%REDIS_PORT%%#${REDIS_PORT}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%REDIS_PORT%%#${REDIS_PORT}#" /usr/local/learninglocker/current/xapi/.env
else
    #set a default if one is not present
    REDIS_PORT="6379"
    sed -i "s#%%REDIS_PORT%%#${REDIS_PORT}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%REDIS_PORT%%#${REDIS_PORT}#" /usr/local/learninglocker/current/xapi/.env
fi

#do a string replace for configuration files for the web root. 
if [[ "${MONGO_PORT}" != "" ]]; then
    sed -i "s#%%MONGO_PORT%%#${MONGO_PORT}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%MONGO_PORT%%#${MONGO_PORT}#" /usr/local/learninglocker/current/xapi/.env
else
    #set a default if one is not present
    MONGO_PORT="27017"
    sed -i "s#%%MONGO_PORT%%#${MONGO_PORT}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%MONGO_PORT%%#${MONGO_PORT}#" /usr/local/learninglocker/current/xapi/.env
fi

#do a string replace for configuration files for the web root. 
if [[ "${MONGO_URL}" != "" ]]; then
    sed -i "s#%%MONGO_URL%%#${MONGO_URL}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%MONGO_URL%%#${MONGO_URL}#" /usr/local/learninglocker/current/xapi/.env
else
    #set a default if one is not present
    MONGO_URL="127.0.0.1"
    sed -i "s#%%MONGO_URL%%#${MONGO_URL}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%MONGO_URL%%#${MONGO_URL}#" /usr/local/learninglocker/current/xapi/.env
fi

#do a string replace for configuration files for the web root. 
if [[ "${SITE_URL}" != "" ]]; then
    sed -i "s#%%SITE_URL%%#${SITE_URL}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%SITE_URL%%#${SITE_URL}#" /usr/local/learninglocker/current/xapi/.env
else
    #set a default if one is not present
    SITE_URL="127.0.0.1"
    sed -i "s#%%SITE_URL%%#${SITE_URL}#" /usr/local/learninglocker/current/webapp/.env
	sed -i "s#%%SITE_URL%%#${SITE_URL}#" /usr/local/learninglocker/current/xapi/.env
fi

service redis-server restart

/usr/local/bin/docker-entrypoint.sh mongod --fork --logpath /var/log/mongo/mongodb.log

mongo --nodb /usr/local/bin/startup.js
#until we come up with a cleaver way to detect if mongo's table has collections or not
#we will be forced to run the build commands and hope nothing get's overwritten. 
cd /usr/local/learninglocker/current/webapp/ && yarn build-all
cd /usr/local/learninglocker/current/xapi/ && npm install && npm run build

cd /usr/local/learninglocker/current/webapp/ && node cli/dist/server createSiteAdmin "ht2testadmin@ht2labs.com" "testOrg" "ChangeMeN0w"

#I want this to run in a sub shell and output to go to txt file
pm2 start /usr/local/learninglocker/current/webapp/pm2/all.json

service nginx restart

cd /

if [[ $# -eq 1 && $1 == "bash" ]]; then
    $@
else
    exec "$@"
fi
