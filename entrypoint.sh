#!/bin/sh
set -e

[ -z "$CRON_SCHEDULE" ] && CRON_SCHEDULE="1/15 * * * *"

echo "$CRON_SCHEDULE /usr/local/bin/php /opt/phpipam-agent/index.php update > /proc/self/fd/1 2>/proc/self/fd/2" > $CRONTAB_FILE
echo "$CRON_SCHEDULE /usr/local/bin/php /opt/phpipam-agent/index.php discover > /proc/self/fd/1 2>/proc/self/fd/2" >> $CRONTAB_FILE
chmod 0644 $CRONTAB_FILE

exec "$@"


