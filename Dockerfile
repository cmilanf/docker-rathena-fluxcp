FROM alpine:3.7

LABEL title="rAthena - FluxCP" \
  maintainer="Carlos Milán Figueredo" \
  version="1.0" \
  url1="https://calnus.com" \
  url2="http://www.hispamsx.org" \
  bbs="telnet://bbs.hispamsx.org" \
  twitter="@cmilanf" \
  thanksto1="Beatriz Sebastián Peña" \
  thanksto2="Alberto Marcos González"

LABEL MYSQL_HOST="Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com." \
  MYSQL_DB="Name of the MySQL database." \
  MYSQL_USER="Database username for authentication." \
  MYSQL_PWD="Password for authenticating with database. WARNING: it will be visible from Azure Portal." \
  SVR_LOGIN_ADDR="Login Server IP address or DNS name." \
  SVR_CHAR_ADDR="Char Server IP address or DNS name." \
  SVR_MAP_ADDR="Map Server IP address or DNS name." \
  INSTALLER_PWD="Installer password."

ENV PHP_FPM_USER=www \
    PHP_FPM_GROUP=www \
    PHP_FPM_LISTEN_MODE=0660 \
    PHP_MEMORY_LIMIT=128M \
    PHP_MAX_UPLOAD=50M \
    PHP_MAX_FILE_UPLOAD=200 \
    PHP_MAX_POST=100M \
    PHP_DISPLAY_ERRORS=On \
    PHP_DISPLAY_STARTUP_ERRORS=On \
    PHP_ERROR_REPORTING=E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR \
    PHP_CGI_FIX_PATHINFO=0

RUN mkdir -p /var/www/fluxcp \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /etc/supervisord.d \
    && apk update \
    && apk add --no-cache nginx php5-fpm php5-pdo php5-pdo_mysql php5-gd gd tidyhtml git nano dos2unix mysql-client bind-tools p7zip supervisor \
    && git clone https://github.com/rathena/FluxCP.git /var/www/fluxcp \
    && adduser -D -g 'www' www \
    && chown -R www:www /var/lib/nginx \
    && chown -R www:www /var/www

RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php5/php-fpm.conf \
    && sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php5/php-fpm.conf \
    && sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php5/php-fpm.conf \
    && sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php5/php-fpm.conf \
    && sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php5/php-fpm.conf \
    && sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php5/php-fpm.conf \
    && sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php5/php.ini \
    && sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php5/php.ini \
    && sed -i "s#error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT#error_reporting = ${PHP_ERROR_REPORTING}#i" /etc/php5/php.ini \
    && sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php5/php.ini \
    && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php5/php.ini \
    && sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php5/php.ini \
    && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php5/php.ini \
    && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php5/php.ini

COPY supervisord.conf /etc/
COPY nginx.conf /etc/nginx/nginx.conf
COPY docker-entrypoint.sh /usr/local/bin/

# Enable only if you have items.7z present in the build: https://rathena.org/board/files/file/2509-item-images/
# COPY items.7z /tmp/
# RUN 7z x /tmp/items.7z -o/var/www/fluxcp \
#     && chown -R www:www /var/www \
#     && rm -f /tmp/items.7z

EXPOSE 80/tcp 443/tcp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
