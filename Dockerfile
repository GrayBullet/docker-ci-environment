FROM ubuntu:16.04
MAINTAINER Tomo Masakura <tomo.masakura@gmail.com>

# Install packages
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends ant libc6:i386 libncurses5:i386 libstdc++6:i386 git build-essential curl wget zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libncurses5-dev lib32z1 lib32ncurses5 lib32stdc++6 unzip && apt-get clean && rm -rf /var/lib/apt/list

# Install Git LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install git-lfs && apt-get clean && rm -rf /var/lib/apt/list

# Install GitLab CI Multi Runner
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash && apt-get install gitlab-ci-multi-runner && apt-get clean && rm -rf /var/lib/apt/list

# Setup GitLab Runner setting script
ADD gitlab-runner.conf /etc/gitlab-runner.conf
RUN mkdir -p /etc/gitlab-runner.conf.d
RUN echo 'source /etc/gitlab-runner.conf' >> /etc/profile

# Install rbenv & ruby-build
ENV RBENV_ROOT /usr/local/.rbenv
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} && git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build
RUN echo 'PATH=${RBENV_ROOT}/bin:$PATH' >> /etc/gitlab-runner.conf.d/rbenv
RUN echo 'eval "$(rbenv init -)"' >> /etc/gitlab-runner.conf.d/rbenv

# Install Ruby
ADD ./install_ruby.sh ${RBENV_ROOT}/install_ruby.sh
ADD ./ruby_versions.list ${RBENV_ROOT}/ruby_versions.list
ENV CONFIGURE_OPTS --disable-install-doc
RUN xargs -L 1 ${RBENV_ROOT}/install_ruby.sh < ${RBENV_ROOT}/ruby_versions.list

# Install nvm
ENV NVM_DIR /usr/local/.nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
RUN echo 'source ${NVM_DIR}/nvm.sh' >> /etc/gitlab-runner.conf.d/nvm

# Install Node.js
ADD ./install_node.sh ${NVM_DIR}/install_node.sh
ADD ./node_versions.list ${NVM_DIR}/node_versions.list
RUN xargs -L 1 ${NVM_DIR}/install_node.sh < ${NVM_DIR}/node_versions.list

# Install OpenJDK
ENV JVM_INSTALL_DIR=/opt/jvm
ADD ./install_java.sh ${JVM_INSTALL_DIR}/install_java.sh
ADD ./java_versions.list ${JVM_INSTALL_DIR}/java_versions.list
RUN xargs -L 1 ${JVM_INSTALL_DIR}/install_java.sh < ${JVM_INSTALL_DIR}/java_versions.list
ENV JAVA_HOME=/usr/local/lib/jvm/java-8-openjdk-amd64

# Setup gradle setting script
ADD setupgradle /etc/gitlab-runner.conf.d/gradle
