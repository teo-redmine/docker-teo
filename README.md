# What is this?

[TODO]

# Prerequisites

To run this application you must have docker installed. Docker-compose is optional but recommended.

[TODO]

# How to use this image

## Run with a Database Container

Running Redmine with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

Running `docker-compose up` will build a docker image and start the service at http://localhost:10083.

### Run the application manually

[TODO]

### Persisting your application

The default docker-compose.yml will mount volumes at /srv/docker/teo for the mysql database, files uploaded to redmine, redmine plugins, etc.


## Run with external Database

Running Redmine with an external database it's possible too. This option is intended for development environment with more than one simultaneous developers.

To run redmine with external database the link with mysql container _MUST BE REMOVED_, and we need to add several environments vars:
- DB_TYPE=mysql
- DB_HOST=mysql.host.es
- DB_PORT=3306
- DB_USER=redmine
- DB_PASS=password
- DB_NAME=redmine_db_name
    
An example docker-compose file to run redmine with compose can be found in _development_env/example/docker-compose.yml_ .

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
