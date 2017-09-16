# Docker Image GitLab CI Build Environment
Docker Image CI Build Environment for GitLab CI Multi Runner.

[Docker Image](https://hub.docker.com/r/graybullet/dockerbuildenv/)

Important: Remove android sdk. If you required Android SDK, you must install by GitLab Runner's setup script.


## Environment
* Apache Ant and Gradle
* Chromium (Set CHROME_BIN env)
* GitLab CI Multi Runner
* zip and unzip command
* nvm ([preinstall Node.js](node_versions.list))
* rbenv ([preinstall Ruby](ruby_versions.list))
* OpenJDK 8 ([preinstall Java](java_versions.list))
* ~~Android SDK~~
  - ~~build-tools (25.0.0, 24.0.3, 23.0.3, 22.0.1, 21.1.2)~~
  - ~~tools, platform-tools, platform~~


## Using
```
$ docker pull graybullet/dockerbuildenv
$ docker run -it graybullet/dockerbuildenv /bin/bash
```


### GitLab CI Multi Runner
If you use the GitLab CI Multi Runner, write `source /etc/gitlab-runner.conf` to your `.gitlab-ci.yml`.

```yml
before_script:
  - source /etc/gitlab-runner.conf
  - bundle install --path vendor/bundle
  - npm install --no-progress
```

