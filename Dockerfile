FROM odoo:8.0

USER root

RUN apt-get update && \
    apt-get install -y python-matplotlib emacs-nox git net-tools tree python-pip file nginx python-dev sudo htop locales locales-all wget fonts-dejavu && \
     pip install gevent psycogreen && \
     #update werkzeug to make phantomjs work. See http://odoo-development.readthedocs.io/en/latest/dev/tests/js.html#regular-phantom-js-tests
     pip install werkzeug --upgrade


# install phantomjs (based on https://hub.docker.com/r/cmfatih/phantomjs/~/dockerfile/ )
ENV PHANTOMJS_VERSION 1.9.8

RUN \
  apt-get install -y libfreetype6 libfontconfig && \
  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION.tar.gz https://github.com/ariya/phantomjs/archive/$PHANTOMJS_VERSION.tar.gz && \
  tar -xzf /tmp/phantomjs-$PHANTOMJS_VERSION.tar.gz -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION.tar.gz && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
  git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs && \
  apt-get autoremove -y && \
  apt-get clean all

# fix access issue with nginx
RUN touch /var/log/nginx/error.log && \
    touch /var/log/nginx/access.log && \
    chown odoo:odoo -R /var/log/nginx && \
    chown odoo:odoo -R /var/lib/nginx/


ENV BUILD_DATE=2016_11_03

RUN git clone -b 8.0 https://github.com/it-projects-llc/runbot-addons.git /mnt/runbot-addons && \
    git clone https://github.com/odoo/odoo-extra.git /mnt/odoo-extra && \
    rm -rf /mnt/odoo-extra/website_twitter_wall

# grant access to work dir
RUN chown odoo:odoo -R /mnt/odoo-extra/runbot/static/

RUN true && \
    # always close cron db connnections
    sed -i "s/if len(db_names) > 1:/if True:/" /usr/lib/python2.7/dist-packages/openerp/service/server.py && \
    # auto_reload
    sed -i -e "s/auto_reload = True/; auto_reload = True/" /etc/odoo/openerp-server.conf && \
    # limits:
    sed -i -e "s/; limit_time_cpu.*/limit_time_cpu = 300/" /etc/odoo/openerp-server.conf && \
    sed -i -e "s/; limit_time_real.*/limit_time_real = 600/" /etc/odoo/openerp-server.conf && \
    # addons_path:
    sed -i -e "s;addons_path.*;addons_path = /mnt/odoo-extra,/mnt/extra-addons,/mnt/runbot-addons,/usr/lib/python2.7/dist-packages/openerp/addons;" /etc/odoo/openerp-server.conf

VOLUME ["/mnt/odoo-extra", "/mnt/runbot-addons"]

CMD ["openerp-server", "--database=runbot", "--db-filter=^runbot$", "--workers=2"]

USER odoo
