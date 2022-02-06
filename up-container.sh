docker container run -it --mount type=bind,src=$(pwd)/src,dst=/nimls/src --mount type=bind,src=$(pwd)/bin,dst=/nimls/bin nimls:latest
