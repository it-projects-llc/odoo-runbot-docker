FROM odoo:8.0

USER root

RUN apt-get update || true && \
    apt-get install -y python-matplotlib emacs-nox git net-tools tree python-pip python3-pip file nginx python-dev sudo htop locales locales-all wget fonts-dejavu && \
    pip install gevent psycogreen && \
    #update werkzeug to make phantomjs work. See http://odoo-development.readthedocs.io/en/latest/dev/tests/js.html#regular-phantom-js-tests
    pip install werkzeug --upgrade && \
    apt-get install -y npm python-lxml libxml2-dev libxslt1-dev && \
    # Extra package for pylint-odoo plugin
    npm install -g jshint



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

# python3 support
# https://unix.stackexchange.com/questions/332641/how-to-install-python-3-6
RUN wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz && \
    tar xvf Python-3.6.3.tgz && \
    cd Python-3.6.3 && \
    ./configure --enable-optimizations && \
    make -j8 && \
    make altinstall && \
    apt-get install -y python3-pip

ENV BUILD_DATE=2016_11_03

RUN git clone -b 8.0 https://github.com/it-projects-llc/runbot-addons.git /mnt/runbot-addons && \
    pip install --upgrade pip setuptools && \
    pip install --upgrade pylint && \
    pip install --upgrade git+https://github.com/oca/pylint-odoo.git && \
    git clone -b runbot-docker https://github.com/yelizariev/odoo-extra.git /mnt/odoo-extra

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
