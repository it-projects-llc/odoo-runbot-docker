# odoo-runbot-docker

The project allows to deploy your own runbot for your odoo repositories.

# Deployment

## Docker engine

First of all you need to install docker engine: https://docs.docker.com/engine/installation/ubuntulinux/

Simplified instruction can be found here: https://github.com/it-projects-llc/install-odoo

## Nginx

Install nginx on your host server

    apt-get install nginx
    
Then add configs for nginx:

* [runbot.conf](nginx-host/runbot.conf) 
  
  * update ``server_name`` if needed

* [odoo_params.conf](nginx-host/odoo_params.conf).


Restart nginx.

## Postfix container (change ``runbot.local`` to your host)

    docker run -e MAILNAME=runbot.local --name postfix -d itprojectsllc/postfix-docker

## Postgres container

Run (create) postgres docker (we use 9.5 due to [postgres bug](https://github.com/odoo/odoo/issues/8585) )

    docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo --name db-9.5 postgres:9.5
    
## Odoo container    

Run (create) runbot container (change ``runbot.local`` to your host)

    docker run \
    -h runbot.local \
    -p 18069:8069 \
    -p 8080:8080 \
    -v /some/path:/var/lib/odoo \
    --link db-9.5:db \
    --link postfix:postfix \
    --name odoo-runbot \
    -t itprojectsllc/odoo-runbot-docker
    
Note. If you need to change something in docker run configuration (e.g. fix host name), you have stop container and then remove it:

    docker rm odoo-runbot

## Github configuration

Create personal *access token* https://github.com/settings/tokens

For each repository create Webhook:

* **link**: http://runbot.local:18069/runbot/hook/misc-addons
 where *misc-addons* is a nickname of your runbot.repo record. 
* **Content Type**: application/x-www-form-urlencoded
* **Which events would you like to trigger this webhook?**: Send me everything.

## Runbot Database

Create database with a name ``runbot`` via the link:

    http://runbot.local:18069/web/database/manager
    
Then install module ``runbot_custom``.

Now, For each repository create runbot.repo record:

* **Repository**: https link, e.g. https://github.com/it-projects-llc/misc-addons.git
* **Mode**: ``Hook`` (for odoo repo - ``Disabled``)
* **Nginx**: ``Yes`` (for odoo repo - ``No``)
* **Github token**: *access token*
* **Extra dependencies**: Odoo and other repos 
* **Install updated modules**: ``Yes`` (for odoo repo - ``No``)
* **Other modules to install automatically**: None
* **Nickname** -- string to be used in urls

Notes for private repository:
* **Repository**: use ssh  link, e.g. ``git@github.com:it-projects-llc/mic-addons.git``
* Configure ssh keys

  * connect to docker as odoo:

  > docker exec -i --user=odoo -t odoo-runbot /bin/bash
 
  * generate key

     > ssh-keygen -t rsa -b 4096 -C "runbot deployment key for private repo"

  * try clone manually once

     > cd /tmp/
 
     > git clone git@github.com:it-projects-llc/misc-addons.git

  * add deployments keys to repo https://developer.github.com/guides/managing-deploy-keys/

## Change master password

    ODOO_MASTER_PASS=`< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-12};echo;`
    docker exec -i -u root -t odoo-runbot sed -i "s/; admin_passwd = admin/admin_passwd = $ODOO_MASTER_PASS/" /etc/odoo/openerp-server.conf.txt

    
## Restart docker

*See below*
    
    
# After deployment

## Container's terminal

For any manipulation inside odoo-runbot container you need to connect to it:

    docker exec -i --user=root -t odoo-runbot /bin/bash 

## Restart containers

    docker stop odoo-runbot && docker stop db-9.5 && docker start db-9.5 && docker start -a odoo-runbot

## External dependencies

Connect to runbot container and install requiremnts, e.g.

    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/odoo-saas-tools/8.0/requirements.txt | pip install

## Update runbot-addons

    docker exec -i --user=root -t odoo-runbot  git -C /mnt/runbot-addons/ pull
