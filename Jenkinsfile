node {
    checkout scm
    try {
      stage("Build") {
          sh 'chmod -R 777 .'
          sh 'docker run --rm \
            -v /root/docker/jenkins/workspace/bp-twittervotes:/go/src/twittervotes \
            -w /go/src/twittervotes \
            golang:latest bash -c "./build.sh alpine"'
          sh 'bash build.sh image'
      }
      stage("Publish") {
          withDockerRegistry([credentialsId: 'DockerHub']) {
              sh 'bash build.sh push'
          }
      }
    } catch(error) {
      throw error
    } finally {
      sh 'rm -rf *'
    }
}
