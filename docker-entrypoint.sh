#!/bin/sh
echo "rAthena Development Team presents - Flux CP"
echo "           ___   __  __"
echo "     _____/   | / /_/ /_  ___  ____  ____ _"
echo "    / ___/ /| |/ __/ __ \/ _ \/ __ \/ __  /"
echo "   / /  / ___ / /_/ / / /  __/ / / / /_/ /"
echo "  /_/  /_/  |_\__/_/ /_/\___/_/ /_/\__,_/"
echo ""
echo "http://rathena.org/board/"
echo ""
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Initalizing Docker container..."
if [ -z "${MYSQL_HOST}" ]; then echo "Missing MYSQL_HOST environment variable. Unable to continue."; exit 1; fi
if [ -z "${MYSQL_DB}" ]; then echo "Missing MYSQL_DB environment variable. Unable to continue."; exit 1; fi
if [ -z "${MYSQL_USER}" ]; then echo "Missing MYSQL_USER environment variable. Unable to continue."; exit 1; fi
if [ -z "${MYSQL_PWD}" ]; then echo "Missing MYSQL_PWD environment variable. Unable to continue."; exit 1; fi

sed -i "16s|127.0.0.1|${MYSQL_HOST}|" /var/www/fluxcp/config/servers.php
sed -i "17s|ragnarok|${MYSQL_USER}|" /var/www/fluxcp/config/servers.php
sed -i "18s|ragnarok|${MYSQL_PWD}|" /var/www/fluxcp/config/servers.php
sed -i "19s|ragnarok|${MYSQL_DB}|" /var/www/fluxcp/config/servers.php
sed -i "37s|127.0.0.1|${MYSQL_HOST}|" /var/www/fluxcp/config/servers.php
sed -i "38s|ragnarok|${MYSQL_USER}|" /var/www/fluxcp/config/servers.php
sed -i "39s|ragnarok|${MYSQL_PWD}|" /var/www/fluxcp/config/servers.php
sed -i "40s|ragnarok|${MYSQL_DB}|" /var/www/fluxcp/config/servers.php
sed -i "56s|true|false|" /var/www/fluxcp/config/servers.php # disable renewal
if ! [ -z "${SVR_LOGIN_ADDR}" ]; then sed -i "46s|127.0.0.1|${SVR_LOGIN_ADDR}|" /var/www/fluxcp/config/servers.php; fi
if ! [ -z "${SVR_CHAR_ADDR}" ]; then sed -i "86s|127.0.0.1|${SVR_CHAR_ADDR}|" /var/www/fluxcp/config/servers.php; fi
if ! [ -z "${SVR_MAP_ADDR}" ]; then sed -i "90s|127.0.0.1|${SVR_MAP_ADDR}|" /var/www/fluxcp/config/servers.php; fi
if ! [ -z "${INSTALLER_PWD}" ]; then sed -i "7s|'secretpassword'|${INSTALLER_PWD}|" /var/www/fluxcp/config/application.php; fi

exec "$@"