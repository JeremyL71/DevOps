FROM python:3.7.6-stretch

RUN pip install pip --upgrade
RUN pip install ansible

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass

RUN mkdir /tmp/ansible
COPY . /tmp/ansible
RUN chmod 400 /tmp/ansible/id_rsa

ENV ANSIBLE_HOST_KEY_CHECKING=False

WORKDIR /tmp/ansible

CMD echo $VAULT_PASS > passwd_file && ansible-vault decrypt --vault-password-file passwd_file id_rsa && ansible-playbook -i inventories/setup.yml playbook.yml