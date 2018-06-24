# Dockerized Flux Control Panel (FluxCP) for rAthena servers.
This repository is a Docker build of [FluxCP](https://github.com/rathena/FluxCP), an open-source control panel for [rAthena](https://github.com/cmilanf/docker-rathena) server software.

  * Build features:
    * Uses [Alpine Linux](https://hub.docker.com/_/alpine/) as base image.
    * Builds from the master branch of FluxCP's Github repository.
  * Runtime features:
    * Session state is stored in process memory, so this image won't scale easily without proper modification.
    * It uses the same MySQL database as the rAthena server
    * The image leverages [NGINX](https://nginx.org/en/) web server and [PHP-FPM](https://php-fpm.org/) through [supervisord](http://supervisord.org/).

## File description

  * **build.bat**. Trivial script that launches docker build.
  * **Dockerfile**. The core of this repo, documented with the LABEL entries.
  * **docker-entrypoint.sh**. The Docker entrypoint that leaves the container in the desired state for execution.
  * **nginx.conf**. The NGINX configuration files, using the PHP-FPM model.
  * **supervisord.conf**. Supervisord configuration file.

## Requeriments
FluxCP requires a [rAthena](https://github.com/cmilanf/docker-rathena) server database in order to work.
The image is based on Alpine Linux and targets to run at Linux x64 architectures.

Footprint is really small.

## Environment variables accepted by the image

  * MYSQL_HOST. Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com.
  * MYSQL_DB. Name of the MySQL database.
  * MYSQL_USER. Database username for authentication.
  * MYSQL_PWD. Password for authenticating with database. WARNING: it will be visible from Azure Portal.
  * SVR_LOGIN_ADDR. Login Server IP address or DNS name.
  * SVR_CHAR_ADDR. Char Server IP address or DNS name.
  * SVR_MAP_ADDR. Map Server IP address or DNS name.
  * INSTALLER_PWD. Installer password.

## Usage
If you have a readily accesible rAthena's MySQL sever and the rAthena server itself, then usage is straight forward:

```
docker run -d --restart=unless-stopped -e MYSQL_HOST="MYSQL host IP" -e MYSQL_USER="MySQL username" -e MYSQL_PWD="MySQL password" -e MYSQL_DB="rAthena"  -e SVR_LOGIN_ADDR="10.0.0.3" -e SVR_CHAR_ADDR="10.0.0.3" -e SVR_MAP_ADDR="10.0.0.3" -e INSTALLER_PWD="p4ss@w0rd" --name rathena-fluxcp cmilanf/docker-rathena-fluxcp:latest
```

## Related projects:

  * [docker-rathena](https://github.com/cmilanf/docker-rathena)
  * [docker-openkore](https://github.com/cmilanf/docker-openkore)

## License
MIT License

Copyright (c) 2018 Carlos Milán Figueredo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.