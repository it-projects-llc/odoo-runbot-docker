FROM itprojectsllc/odoo-runbot-docker

USER root

RUN apt-get install -y libffi-dev libssl-dev

RUN wget -q -O- https://raw.githubusercontent.com/it-projects-llc/misc-addons/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/pos-addons/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/mail-addons/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/rental-addons/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/access-addons/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/website-addons/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/l10n-addons/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/odoo-telegram/8.0/requirements.txt | xargs pip install && \
    wget -q -O- https://raw.githubusercontent.com/it-projects-llc/odoo-saas-tools/8.0/requirements.txt | xargs pip install

USER odoo

