FROM itprojectsllc/odoo-runbot-docker

USER root

RUN true && \
    # configs for saas
    sed -i -e "s/; limit_time_cpu = 60/limit_time_cpu = 600/" /etc/odoo/openerp-server.conf && \
    sed -i -e "s/; limit_time_real = 120/limit_time_real = 1200/" /etc/odoo/openerp-server.conf

ENV BUILD_DATE_CUSTOM=2016_08_05

RUN apt-get install -y libffi-dev libssl-dev python-pandas

RUN pip install -r https://raw.githubusercontent.com/it-projects-llc/misc-addons/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/pos-addons/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/mail-addons/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/rental-addons/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/access-addons/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/website-addons/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/l10n-addons/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/odoo-telegram/8.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/odoo-saas-tools/8.0/requirements.txt || true

RUN pip install -r https://raw.githubusercontent.com/it-projects-llc/misc-addons/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/pos-addons/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/mail-addons/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/rental-addons/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/access-addons/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/website-addons/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/l10n-addons/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/odoo-telegram/9.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/odoo-saas-tools/9.0/requirements.txt || true

RUN pip install -r https://raw.githubusercontent.com/it-projects-llc/misc-addons/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/pos-addons/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/mail-addons/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/rental-addons/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/access-addons/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/website-addons/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/l10n-addons/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/odoo-telegram/10.0/requirements.txt || true && \
    pip install -r https://raw.githubusercontent.com/it-projects-llc/odoo-saas-tools/10.0/requirements.txt || true

RUN pip3 install -r https://raw.githubusercontent.com/it-projects-llc/misc-addons/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/pos-addons/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/mail-addons/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/rental-addons/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/access-addons/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/website-addons/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/l10n-addons/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/odoo-telegram/11.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/odoo-saas-tools/11.0/requirements.txt || true

RUN pip3 install -r https://raw.githubusercontent.com/it-projects-llc/misc-addons/12.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/pos-addons/12.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/mail-addons/12.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/access-addons/12.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/website-addons/12.0/requirements.txt || true && \
    pip3 install -r https://raw.githubusercontent.com/it-projects-llc/saas-addons/12.0/requirements.txt || true

USER odoo

