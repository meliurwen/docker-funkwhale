# Funkwhale container stack

This is a rewriting of the official Funkwhale multi-container installation.

## Why

The official docker-compose works, but is written in some very questionable way;
creating serious issues in security, portability, modularity, readability and
maintenability of the entire stack. The installation is also not automated, but
requires extra steps (excluding configuration that doesn't count) to initialize
for the first time the instance.

## What changed

There has been a **_lot_** of changes, I will list the most notable ones:

### Network

+ **Before:** _(see [the appendix](###Network-Before))_
  + the containers were all under the same network which gave them internet access;
  + the `api` and `nginx` (the reverse-proxy) services were exposing to the public (using the `port` directive), respectively the `5000/tcp` and `80/tcp` ports;
  + the ports of `postgres` and `redis` were not documented (no `expose` directive used).
+ **Now:** _(see [the appendix](###Network-Now))_
  + There are _three_ distinct networks with precise purposes:
    1. An internal network (no Internet access) containing all the services;
    2. A network with Internet access with only the services that _really_ need it, namely: `api` and `celeryworker`;
    3. An optional external network to hook the `nginx` service only (in case you have a main reverse-proxy on your server).
  + the `api` and `nginx` (the reverse-proxy) services no longer expose their ports to the public, they are only documented with the `expose` directive;
  + the ports of `postgres` and `redis` services are now documented with the `expose` directive.

### Environment variables

> **Info:** read [this](https://docs.docker.com/compose/env-file/) and [this](https://docs.docker.com/compose/compose-file/#env_file) on the official Docker docs to understand the difference between `.env` file and env files imported with `env_file`.

+ **Before:**
  + All the environment variables for all services were mixed together inside the same `*.env` file (`.env`);
  + The `.env` file (which is automatically loaded by Docker Compose to be used within the `.yml` file), is also directly injected in all serivices with the `env_file` directive, exposing information to services that doesn't (and shouldn't) need it.
+ **Now:**
  + The environment variables are now separated in different files depending on the service or set of services that does need them; the `.env` file now has only variables concerning the configuration at the _stack level_, not service, except for the `FUNKWHALE_HOSTNAME` variable which is passed inside the containers via the `environment` directive.
  + The `env_file` is now used only when needed and import `*.env` files containing variables only needed for the target service.

### Other

+ Configurable paths for the volumes mounting point **_inside_** the containers has been removed, it's something that has no sense to exist and unnecessarily complicate things.
+ Has been added the possibility to configure the `restart` and `container_name` directive on all the containers.
+ Has been added the possibility to configure the **_tag_** on all services and **_image_** on some (`nginx`, `postgres`, `redis`).
+ In the `funkwhale.template` has been removed all the unnecessary variables and replaced with static paths which reflects the static volume mountpoints I set for the service.
+ The `funkwhale_proxy.conf` and  `funkwhale.template` has been moved to a dedicated subfolder called `nginx`.
+ In case the system administrator has intention to hook the `nginx` service to the network of its _main_ reverse-proxy which happens to have a companion (for example [docker-gen](https://github.com/jwilder/docker-gen)) I've set some variables with dummy values already in the `nginx.env` file.
+ The directives in the `docker-compose.yml` file now are no longer sorted randomly; the order is the same for all and follows a criteria that (arguably) makes more sense.
+ Except for `DJANGO_SECRET_KEY` and `FUNKWHALE_HOSTNAME` which are mandatory variables to manually set, all the optional variables are left empty in the `*.var` files by default and has a correspondent default value defined in the `docker-compose.yml` file (except for `funkwhale.env`).
+ `postgres` service image tag has been upgraded from `11` to `12.4` and `redis` from to `5` to `6`.

## What Didn't Change

+ The overall stack structure remained the same, with the same container images.
+ The name of the services (but they should be changed to a more generic ones,
like: `web`, `api`, `db`, `cache`, etc...).
+ The extra manual steps necessary to initialize for the first time the app
+ The extra manual steps necessary to partially initialize the database in case
to upgrade to a new version (tables or columns has been added/removed)
+ The extra manual steps in case of bump to a new version of the service that is
not backward compatible (for example posgres likes to break compatibility at every
major release).

## How to Install

### Configuration

These are the minimum number of variables you need to set in order to get the
whole stack working.

+ Remove the `.example` extension from all files (or copy new ones without it)
+ Set the `DJANGO_SECRET_KEY` variable in `funkwhale.env`
+ Set the `FUNKWHALE_HOSTNAME` variable in `.env`
+ _(only if using a reverse proxy with docker-companion)_ set the dedicated variables in
`nginx.env`

### Initialization (only first time)

Initialize the database:

```sh
docker-compose run --rm api python manage.py migrate
```

Create the superuser of the instance:

```sh
docker-compose run --rm api python manage.py createsuperuser
```

### Run

Launch the whole stack:

```sh
docker-compose build --pull && docker-compose up -d
```

## Resources

+ [FW GitLab istance - docker-compose.yml](https://dev.funkwhale.audio/funkwhale/funkwhale/-/blob/develop/deploy/docker-compose.yml)
+ [FW Docs - Docker installation](https://docs.funkwhale.audio/installation/docker.html)
+ [FW Docs - Architecture](https://docs.funkwhale.audio/developers/architecture.html)
+ [FW Docs - Instance configuration](https://docs.funkwhale.audio/admin/configuration.html)

## Appendix

### Network Before

![Network Before](.git/media/network-before.png)

### Network Now

![Network Now](.git/media/network-now.png)
