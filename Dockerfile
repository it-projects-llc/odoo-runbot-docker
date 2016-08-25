FROM odoo:8.0

RUN apt-get update && \
    apt-get install -y python-matplotlib emacs-nox git net-tools tree python-pip file nginx python-dev sudo htop locales locales-all postfix wget fonts-dejavu && \
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
RUN service nginx reload && \
    service nginx start && \
    service nginx stop && \
    chown odoo:odoo -R /var/log/nginx



ENV BUILD_DATE=2016_08_05

RUN git clone https://github.com/yelizariev/runbot-addons.git /mnt/runbot-addons && \
    git clone https://github.com/odoo/odoo-extra.git /mnt/odoo-extra

# grant access to work dir
RUN chown odoo:odoo -R /mnt/odoo-extra/runbot/static/


# Update config
# TODO addons path
# TODO dbfilter

# update entrypoint.sh


# TODO. After restarting docker, you  need to trigger hook:
# runbot.example.com:18069/runbot/hook/1
# it's required to reload nginx

