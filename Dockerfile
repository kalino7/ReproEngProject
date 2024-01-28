# Long-term maintained base distribution
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"
ENV NODE_MAJOR=18 

#Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
		ca-certificates \
        curl \
		git \
        gnupg \
        python3 \
        python3-pip \
		sudo \ 
        texlive-base \
        texlive-bibtex-extra \
        texlive-fonts-extra \
        texlive-fonts-recommended \
        texlive-plain-generic \
        texlive-latex-extra \
        texlive-publishers

#install nodejs and npm package
RUN sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
        sudo apt-get update && \
        sudo apt-get install nodejs -y

# Add user
RUN useradd -m -G sudo -s /bin/bash kali \
    && echo "kali:kali" | chpasswd \
    && usermod -a -G staff kali

# create a working directory
WORKDIR /home/kali

# Clone the repository
RUN git clone https://github.com/feekosta/JSONSchemaDiscovery 

# set new working directory
WORKDIR /home/kali/JSONSchemaDiscovery

#copy patches. and relevant files
COPY --chown=kali:kali ./doAll.sh .
COPY --chown=kali:kali ./makefile .
COPY --chown=kali:kali ./csv csv
COPY --chown=kali:kali ./patches patches
COPY --chown=kali:kali ./script script

#run patches
RUN  patch karma.conf.js ./patches/karma.patch
RUN  patch package.json ./patches/package.patch

#install global dependencies
RUN npm install -g @angular/cli@13.3.11 && \
    npm install -g typescript@4.6.3

RUN npm install

#clone repo containing the latex code
RUN git clone https://github.com/kalino7/ReproEngReport

#clone datasets for experiment
RUN git clone https://github.com/kalino7/datasets

# install python libraries
RUN pip install pymongo python-dotenv requests

#make doAll.sh executeable
RUN chmod +x doAll.sh

EXPOSE 4200