This repo contains a recipe for making a [Docker](http://docker.io) container
for Wordpress using Apache. To build, make sure you have Docker
[installed](http://www.docker.io/gettingstarted/), clone this repo somewhere,
and then run:

```
docker build -rm -t <your_image_name> .
```

You'll need to bring your own MySQL DB. An easy way to do this (at least to
start) is to simply run another docker container:

```
# This docker image will create a DB and grant privledges. Nice.
docker run -d \
  -e MYSQL_DATABASE=<wordpress_mysql_db_name> \
  -e MYSQL_USER=<wordpress_mysql_username> \
  -e MYSQL_PASSWORD=<wordpress_mysql_password> \
  -name wpmysql
  orchardup/mysql
```

Then, we can run our wordpress container, linking it to the existing `wpmysql`
container:

```
sudo docker run -i -t -p 80:80 -e WP_DB=<wordpress_mysql_db_name> -e WP_USER=<wordpress_mysql_username> -e WP_PASS=<wordpress_mysql_password> -link wpmysql:mysql <your_image_name>
```

The `start.sh` script automatically uses the IP address provided by the docker
link to `mysql`. If you want to specify your our IP address to a remotely hosted
MySQL instance, you can simply run the command above, but instead of linking to
a mysql container, just pass in another env var to the `docker run` command as
```... -e MYSQL_HOST=<your_mysql_host> ...```

If you don't want to attach this directly to port 80 (maybe you want to run it
behind nginx and host multiple sites on one machine), just drop the `-p 80:80`
(and also the `sudo`) and forward traffic to the IP address of the container,
just use `-p 80` and docker will auto-bind it to a localhost port, or bind it
to, say, 8080 using `-p 8080:80` and then bind your other site to a different
port.
