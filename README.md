# phpipam-agent

phpIPAM is an open-source web IP address management application. Its goal is to provide light and simple IP address management application.

phpIPAM is developed and maintained by Miha Petkovsek, released under the GPL v3 license, project source is [here](https://github.com/phpipam/phpipam-agent)

Learn more on [phpIPAM homepage](http://phpipam.net)

This container can be used as a discovery scan agent.

## How to use this Docker image

### Setup PHPIPAM

* Configure a remote agent (Administration > scan agents), get the key.
![config_agent](https://user-images.githubusercontent.com/4225738/45190599-0b799000-b23f-11e8-9e41-fb993606264d.png)

* For each subnet, enable scan & configure the remote agent by selecting a remote.
![config_subnet](https://user-images.githubusercontent.com/4225738/45190619-2ba94f00-b23f-11e8-9e45-b5e721c63d70.png)

## Scheduled scans

For scheduled scans you have to run script from cron. Add something like following to your cron to scan each 15 minutes:
```bash
1/15 * * * * php /where/your/agent/index.php update
1/15 * * * * php /where/your/agent/index.php discover
```

### Run this container

```bash
version: '2'
services:
    phpipam-agent:
        container_name: phpipam-agent
        restart: unless-stopped
        image: mc303/phpipam-agent:latest
        environment:
          - MYSQL_ENV_MYSQL_HOST=10.10.1.10
          - MYSQL_ENV_MYSQL_DATABASE=phpipam
          - MYSQL_ENV_MYSQL_USER=phpipam
          - MYSQL_ENV_MYSQL_PASSWORD=phpipam
          - MYSQL_ENV_MYSQL_PORT=3307
          - PHPIPAM_AGENT_KEY=abcder1223456xczxcsad
          - CRON_SCHEDULE=1/15 * * * *
          - TZ=Europe/Amsterdam    
        ports:
          - "3306:3306"
```

Now, the discovery scans will be performed every 1mn by default.

The logs are available on stdout/stderr (allowing to use `docker logs`).

# Acknowledgements

Based on [pierrecdn/phpipam-agent](https://github.com/pierrecdn/phpipam-agent), [published on docker hub](https://hub.docker.com/r/pierrecdn/phpipam-agent).


## docker-phpipam-agent
