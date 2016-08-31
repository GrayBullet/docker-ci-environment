FROM ubuntu:14.04
MAINTAINER Tomo Masakura <tomo.masakura@gmail.com>

# Install packages
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends default-jdk ant libc6:i386 libncurses5:i386 libstdc++6:i386 git build-essential curl wget zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libncurses5-dev lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6 expect && apt-get clean && rm -rf /var/lib/apt/list

# Install GitLab CI Multi Runner
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash && apt-get install gitlab-ci-multi-runner && apt-get clean && rm -rf /var/lib/apt/list

# Install rbenv & ruby-build
ENV RBENV_ROOT /usr/local/.rbenv
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} && git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build
RUN echo 'PATH=${RBENV_ROOT}/bin:$PATH' >> /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile

# Install Ruby
ADD ./install_ruby.sh ${RBENV_ROOT}/install_ruby.sh
ADD ./ruby_versions.list ${RBENV_ROOT}/ruby_versions.list
ENV CONFIGURE_OPTS --disable-install-doc
RUN xargs -L 1 ${RBENV_ROOT}/install_ruby.sh < ${RBENV_ROOT}/ruby_versions.list

# Install nvm
ENV NVM_DIR /usr/local/.nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash
RUN echo 'source ${NVM_DIR}/nvm.sh' >> /etc/profile

# Install Node.js
ADD ./install_node.sh ${NVM_DIR}/install_node.sh
ADD ./node_versions.list ${NVM_DIR}/node_versions.list
RUN xargs -L 1 ${NVM_DIR}/install_node.sh < ${NVM_DIR}/node_versions.list

# Install Android SDK
ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN curl -L http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | tar zxvf - --no-same-permissions --no-same-owner -C /tmp && mv /tmp/android-sdk-linux ${ANDROID_HOME}
RUN echo 'PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools' >> /etc/profile
ARG ANDROID_SDK_DOWNLOAD_PROXY_HOST
ARG ANDROID_SDK_DOWNLOAD_PROXY_PORT
ADD androidsdk_wrapper.sh ${ANDROID_HOME}/androidsdk_wrapper.sh
RUN ${ANDROID_HOME}/androidsdk_wrapper.sh update sdk --no-ui --no-https --filter tools
RUN ${ANDROID_HOME}/androidsdk_wrapper.sh update sdk --no-ui --no-https --all --filter build-tools-24.0.2,build-tools-23.0.3,build-tools-22.0.1,build-tools-21.1.2
RUN ${ANDROID_HOME}/androidsdk_wrapper.sh update sdk --no-ui --no-https --filter platform-tools,platform
ADD setupgradle.sh /etc/setupgradle.sh
RUN echo 'source /etc/setupgradle.sh' >> /etc/profile
