FROM ubuntu:20.04

ARG TERRAFORM_VERSION=latest
ARG PACKER_VERSION=latest
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG DEBIAN_FRONTEND=noninteractive

ENV ENV_TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV ENV_PACKER_VERSION=${PACKER_VERSION}

RUN apt-get clean && rm -R --force /var/lib/apt/lists/* \ 
  && apt-get update

RUN apt-get update --yes && \
  apt-get --yes install \
  coreutils \
  curl \
  direnv \
  expect \
  gawk \
  git \
  groff \
  less \
  lsb-release \
  moreutils \
  parallel \
  python3-pip \
  unzip \
  wget \
  && rm --recursive --force /var/lib/apt/lists/*

RUN pip3 install --upgrade --no-cache-dir\
  ansible \
  awscli \
  bashplotlib \
  csvkit \
  httpie \
  jinja2 \
  matplotlib \
  netaddr \
  pandas \
  pip \
  python-dateutil \
  pywinrm \
  virtualenv \
  virtualenvwrapper \
  ;

RUN apt-get clean --yes \
  && rm --recursive --force /var/lib/apt/lists/*


RUN curl --output "terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip" \
  --silent \
  --show-error \
  --location \
  "https://releases.hashicorp.com/terraform/${ENV_TERRAFORM_VERSION}/terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip"
RUN unzip "terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip" \
  && rm --force "terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip"
RUN chmod +x terraform
RUN mv terraform /usr/local/bin

RUN curl --output "packer_${ENV_PACKER_VERSION}_linux_amd64.zip" \
  --silent \
  --show-error \
  --location \
  "https://releases.hashicorp.com/packer/${ENV_PACKER_VERSION}/packer_${ENV_PACKER_VERSION}_linux_amd64.zip"
RUN unzip "packer_${ENV_PACKER_VERSION}_linux_amd64.zip" \
  && rm --force "packer_${ENV_PACKER_VERSION}_linux_amd64.zip"
RUN chmod +x packer
RUN mv packer /usr/local/bin

#RUN groupadd --gid ${GROUP_ID} users || true 
RUN useradd --create-home --shell /bin/sh packer-user || true


USER packer-user

WORKDIR /home/packer-user
RUN mkdir --parents .ssh/
