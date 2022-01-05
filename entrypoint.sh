#!/bin/sh
set -e

case "$SCAN_INTERVAL" in
  5m)  CRON_S="*/5 *"
  ;;
  10m) CRON_S="*/10 *"
  ;;
  15m) CRON_S="*/15 *"
  ;;
  30m) CRON_S="*/30 *"
  ;;
  1h)  CRON_S="0 *"
  ;;
  2h)  CRON_S="0 */2"
  ;;
  4h)  CRON_S="0 */4"
  ;;
  6h)  CRON_S="0 */6"
  ;;
  12h) CRON_S="0 */12"
  ;;
  *)   CRON_S="0 *"
  ;;
esac

echo "$CRON_S * * * /usr/local/bin/php /opt/phpipam-agent/index.php update > /proc/self/fd/1 2>/proc/self/fd/2" > $CRONTAB_FILE
echo "$CRON_S * * * /usr/local/bin/php /opt/phpipam-agent/index.php discover > /proc/self/fd/1 2>/proc/self/fd/2" >> $CRONTAB_FILE
chmod 0644 $CRONTAB_FILE

exec "$@"


