#!/bin/bash
chown www-data:www-data /app -R

if [ "$ALLOW_OVERRIDE" = "**False**" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    a2enmod rewrite
fi

if [ -d "$KOD_SYSTEM_PATH" ] ; then
    chown www-data:www-data "$KOD_SYSTEM_PATH" -R
    if [ ! "$(ls -A $KOD_SYSTEM_PATH)" ]; then
        su www-data
        cp /app/data/system/* "$KOD_SYSTEM_PATH/"
        echo "Copy system files."
    fi
fi

if [ -d "$KOD_USER_PATH" ] ; then
    chown www-data:www-data "$KOD_USER_PATH" -R
    if [ ! "$(ls -A $KOD_USER_PATH)" ]; then
        su www-data
        cp /app/data/User/* "$KOD_USER_PATH/"
        echo "Copy user files."
    fi
fi

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
