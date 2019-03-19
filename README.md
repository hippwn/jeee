# Java EE Environment

`jeee` is a simple Java EE development environment based on docker that you can deploy on will. It contains a [MariaDB](https://mariadb.com/) database and a [phpMyAdmin](https://www.phpmyadmin.net/) server, alongside the [Tomcat](https://tomcat.apache.org) execution server that will run your application. 

> **Disclaimer**: `jeee` has been created to help people getting a working development environment quickly. Do **not** use `jeee` as a production environment without modifications and without knowing what you do.


## Installing `jeee`

Be sure to have `docker`, `docker-compose` and `git` installed on your machine. Then, just run the following command in your favorite shell.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hippwn/jeee/master/tools/install.sh)"
```

If you just want the *docker*-based environment, you can `git clone` this repository anywhere you need.


## What's in `jeee`?

Alongside with the containers, `jeee` provides the following content:
- the `jeee` command. More about this one below.
- the `webapps` directory &ndash; it's a [bind volume](https://docs.docker.com/storage/bind-mounts/) with the Tomcat server, just put you `.war` inside to see it executed.
- the `example` application &ndash; it's a simple sample that you can check to see if your environment is running, visit `http://localhost:8888/example` in your favorite browser.

> `example` can also guide you to develop your first Java EE application. Watch the directory content to find out more.

The containers provide the following services

| Service    | Port | Container name | Information              |
| ---------- |:----:| -------------- | ------------------------ |
| Tomcat     | 8888 | `jeee_tomcat`  | *webapps* are loaded from `$JEEE_HOME/webapps` |
| Mariadb    | 3306 | `jeee_mariadb` | root password: `mariadb` |
| phpMyAdmin | 8080 | `jeee_myadmin` | &ndash;                  |


## About the `jeee` command

Jeee provides a wrapper around the `docker-compose` command that allows you to control your environment from basically anywhere on your system. You can of course still use `docker-compose` to control any container, including jeee's. 

```
Usage: jeee COMMAND [OPTIONS]

A commander for your Java EE Environment.

Available commands:
    run             Start the environment
    stop            Stop the environment
    add-workspace   Add a link to the Tomcat workspace
    remove          Remove the containers
    log             Display logs from the containers
    uninstall       Uninstall jeee
```
