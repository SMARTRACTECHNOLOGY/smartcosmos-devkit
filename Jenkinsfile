node {

  stage 'checkout'
  checkout scm

  dir('docker') {
    stage 'docker build smartcosmos/java'
    def tag = (env.BRANCH_NAME == 'master') ? 'latest' : 'snapshot'

    def javaImage = docker.build "smartcosmos/java:${tag}", "java"
    stage 'docker build smartcosmos/service'
    def serviceImage = docker.build "smartcosmos/service:${tag}", "service"

    if (env.BRANCH_NAME == 'master') {
      stage 'push images'
      docker.withRegistry('https://docker.io/', 'dockerhub-credentials')
      javaImage.push('latest')
      serviceImage.push('latest')
    }
  }
}
