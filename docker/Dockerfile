FROM centos:7

# install nodejs
RUN yum install -y epel-release && \
yum install -y nodejs && \
yum install -y git  


WORKDIR /hexo
RUN \
    npm install hexo-cli -g && \
    hexo init . && \
    npm install && \
    npm install hexo-server --save && \
    npm install hexo-generator-sitemap --save && \
    npm install hexo-generator-feed --save && \
    npm install hexo-deployer-git --save


RUN \
    git config --global user.name "kkk33" && \
    git config --global user.email "angellmon386@gmail.com"

