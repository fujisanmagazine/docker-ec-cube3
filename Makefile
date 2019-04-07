NAME=tanomail
VERSION=latest

build:
	docker build --rm --build-arg ECCUBE_DBTYPE=sqlite3 -t $(NAME):$(VERSION) .

restart: stop start

run: start logs

start:
	docker run -d \
        --name $(NAME) \
        -e ECCUBE_DBTYPE="sqlite3" \
		-p 0.0.0.0:8080:80 \
		$(NAME):$(VERSION)

#        -v xxx:xxx \

container=`docker ps -a -q`
image=`docker images | awk '/^<none>/ { print $$3 }'`

clean:
	@if [ "$(image)" != "" ] ; then \
        docker rmi $(image); \
    fi
	@if [ "$(container)" != "" ] ; then \
        docker rm $(container); \
    fi

kill: stop

stop:
	docker stop $(NAME)
	docker rm $(NAME)

attach:
	docker exec -it $(NAME) /bin/bash

logs:
	docker logs -f $(NAME)
