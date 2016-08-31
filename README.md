# Docker Image GitLab CI Build Environment
Docker Image CI Build Environment for GitLab CI Multi Runner.

[Docker Image](https://hub.docker.com/r/graybullet/dockerbuildenv/)


## Environment
* Apache Ant
* GitLab CI Multi Runner
* nvm ([preinstall Node.js](node_versions.list))
* rbenv ([preinstall Ruby](ruby_versions.list))
* OpenJDK 7
* Android SDK
  - build-tools (24.0.2, 23.0.3, 22.0.1, 21.1.2)
  - tools, platform-tools, platform


## Using
```
$ docker pull graybullet/dockerbuildenv
$ docker run -it graybullet/dockerbuildenv /bin/bash
```


### GitLab CI Multi Runner
If you use the GitLab CI Multi Runner, write `source /etc/profile` to your `.gitlab-ci.yml`.

```yml
before_script:
  - source /root/.bashrc
  - bundle install --path vendor/bundle
  - nvm use stable && npm install --no-progress
```
