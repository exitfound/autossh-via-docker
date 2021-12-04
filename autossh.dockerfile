FROM opensuse/leap:15.3 AS autossh

ARG SSH_PRV_KEY
ENV SSH_PRV_KEY=${SSH_PRV_KEY}
RUN zypper --non-interactive --no-gpg-checks refresh \
    && zypper --non-interactive --no-gpg-checks update \
    && zypper --non-interactive --no-gpg-checks install -y \
    vim \
    curl \
    wget \
    autossh \
    net-tools \
    iputils \
    iproute2 \
    iproute2-arpd \
    iproxy

RUN useradd -g users -d /home/autossh autossh
RUN mkdir -p /home/autossh/.ssh/ \
    && chmod -R 700 /home/autossh/.ssh \
    && echo "$SSH_PRV_KEY" > /home/autossh/.ssh/id_rsa \
    && chmod 600 /home/autossh/.ssh/id_rsa \ 
    && chown -R autossh:users /home/autossh

WORKDIR /home/autossh/
USER autossh

ENTRYPOINT ["autossh", "-N", "-M", "0", "-o", "ServerAliveInterval 45", "-o", "ServerAliveCountMax 2", "-o", "StrictHostKeyChecking no", "-i", "/home/autossh/.ssh/id_rsa", "-L", "8080:localhost:80", "root@34.88.132.198"]