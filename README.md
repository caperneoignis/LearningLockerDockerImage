# LearningLockerDockerImage
This is a docker file that will build Learning Locker V2, with default values, you can also set the redis and mongo url's and port through -e commands at run time. 


# Docker Image commands

The purpose of this image is to be able to run Learning Locker V2 in a docker image. You can use the included MongoDB and Redis servers in the image, or set your own through -e.
So if you want persistent data you can use an external Mongo database or for pure testing just use the interal. 
I have setup volume for the MongoDB, however, I have not fully tested it long term.

If you run Mongo externally, ensure you set the database to learninglocker_v2, Redis DB can be changed from 0 to whatever using ' -e REDIS_DB=1 ' . 

| Variables| default |
|----------|---------|
| REDIS_DB | 0 |
| REDIS_URL | 127.0.0.1 |
| REDIS_PORT | 6379 |
| MONGO_PORT | 27017 |
| MONGO_URL | localhost |
| *SITE_URL | 127.0.0.1 | 

*NGINX is set to listen on all traffic on port 80, however LL needs a setting for Site URL if you are planning on hitting it from outside of your computer so 127.0.0.1 will not work, you will need to set to your host IP. 

# How to run

````
docker run -d -e MONGO_URL={some_url} -e SITE_URL={hostIP} -p 80:80 --name LL caperneoignis/learning_locker_v2:latest
````

To run with defaults just use
````
docker run -d -p 80:80 --name LL caperneoignis/learning_locker_v2:latest
````

To run with volume for persistent data
````
docker run -d -p 80:80 -v some_volume:/var/lib/mongo:rw --name LL caperneoignis/learning_locker_v2:latest
````