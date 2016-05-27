# What is this?

[TODO]

# Prerequisites

To run this application you need [TODO]

# How to use this image

## Run with a Database Container

Running Redmine with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

Running `docker-compose up` will build a docker image and start the service at http://localhost:10083.

### Run the application manually

[TODO]

## Persisting your application

The default docker-compose.yml will mount volumes at /srv/docker/teo for the mysql database, files uploaded to redmine, redmine plugins, etc.

# Upgrade this application

Get the last versions of the files needed to build the container pulling from the git repository.

# Configuration

## Environment variables

See https://github.com/sameersbn/docker-redmine/tree/3.1.1-3. Additionally, the following variables are available:

- `TEO_ENV`: Setting it to `development` will print through console information useful for development such as database queries.

Be sure to adjust `dns:` appropriately in `docker-compose.yml`

# Backing up your application

[TODO]

# Restoring a backup

[TODO]

# Contributing

[TODO]

# Issues

[TODO]

# License

EUPL
