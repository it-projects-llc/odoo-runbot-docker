FROM odoo:8.0

USER root

RUN apt-get update && \
    apt-get install -y python-matplotlib emacs-nox git net-tools tree python-pip file nginx python-dev sudo htop locales locales-all wget fonts-dejavu && \
     pip install gevent psycogreen && \
     #update werkzeug to make phantomjs work. See http://odoo-development.readthedocs.io/en/latest/dev/tests/js.html#regular-phantom-js-tests
     pip install werkzeug --upgrade


# install phantom. Taken from https://gist.github.com/julionc/7476620/
RUN apt-get update && \
    apt-get install build-essential chrpath libssl-dev libxft-dev -y && \
    apt-get install libfreetype6 libfreetype6-dev -y && \
    apt-get install libfontconfig1 libfontconfig1-dev -y

ENV PHANTOM_VERSION="phantomjs-1.9.8"
ENV PHANTOM_JS="$PHANTOM_VERSION-linux-i686"

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 && \
    tar xvjf $PHANTOM_JS.tar.bz2 && \
    mv $PHANTOM_JS /usr/local/share && \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

# fix access issue with nginx
RUN touch /var/log/nginx/error.log && \
    touch /var/log/nginx/access.log && \
    chown odoo:odoo -R /var/log/nginx



ENV BUILD_DATE=2016_08_05

RUN git clone -b 8.0 https://github.com/yelizariev/runbot-addons.git /mnt/runbot-addons && \
    git clone https://github.com/odoo/odoo-extra.git /mnt/odoo-extra && \
    rm -rf /mnt/odoo-extra/website_twitter_wall

# grant access to work dir
RUN chown odoo:odoo -R /mnt/odoo-extra/runbot/static/

RUN true && \
    # auto_reload
    sed -i -e "s/auto_reload = True/; auto_reload = True/" /etc/odoo/openerp-server.conf && \
    # addons_path:
    sed -i -e "s;addons_path.*;addons_path = /mnt/odoo-extra,/mnt/extra-addons,/mnt/runbot-addons,/usr/lib/python2.7/dist-packages/openerp/addons;" /etc/odoo/openerp-server.conf && \
    # db_name:
    sed -i -e "s/; db_name.*/db_name = runbot/" /etc/odoo/openerp-server.conf && \
    # dbfilter:
    sed -i -e "s/; dbfilter.*/dbfilter = ^runbot$/" /etc/odoo/openerp-server.conf

VOLUME ["/mnt/odoo-extra", "/mnt/runbot-addons"]

USER odoo
