# Java EE Environment

`jeee` is a simple Java EE environment based on docker that you can deploy on will. It contains a [MariaDB](https://mariadb.com/) database and a [phpMyAdmin](https://www.phpmyadmin.net/) server, alongside the [Tomcat](https://tomcat.apache.org) execution server that will run your application. 



## Installing `jeee`

```bash
git clone https://github.com/hippwn/jeee.git
cd jeee
docker-compose up -d
```

## What's in `jeee`?

Alongside with the containers, `jeee` provides the following content:
- the `webapps` directory &ndash; it's a bind volume with the Tomcat server, just put you `.war` inside to see it executed.
- the `example` application &ndash; it's a simple sample that you can check to see if your environment is running, visit `http://localhost:8888/example` in your favorite browser.

> `example` can also guide you to develop your first Java EE application. Watch the directory content to find out more.
