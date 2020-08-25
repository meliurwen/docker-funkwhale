# Funkwhale container stack

This is a rewriting of the official Funkwhale multi-container installation.

## Why

The official docker-compose works, but is written in some very questionable way;
creating serious issues in security, portability, modularity, readability and
maintenability of the entire stack. The installation is also not automated, but
requires extra steps (excluding configuration that doesn't count) to initialize
for the first time the instance.

## How install

### Configuration

These are the minimum number of variables you need to set in order to get the
whole stack working.

+ Remove the `.example` extension from all files (or copy new ones without it)
+ Set the `DJANGO_SECRET_KEY` variable in `all.env`
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
