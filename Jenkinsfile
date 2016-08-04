node {

  stage 'checkout'
  checkout scm

  dir('docker') {
    def tag = (env.BRANCH_NAME == 'master') ? env.BUILD_NUMBER : "snapshot-${env.BUILD_NUMBER}"


    stage 'docker build smartcosmos/java'
    def javaImage = docker.build "smartcosmos/java:${tag}", "java"


    stage 'docker build smartcosmos/service'
    def serviceImage = docker.build "smartcosmos/service:${tag}", "service"

    stage 'docker build smartcosmos/node-service'
    def nodeServiceImage = docker.build "smartcosmos/node-service:${tag}", "node-service"

    if (env.BRANCH_NAME == 'master') {
      stage 'push images'

      docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
        javaImage.push('latest')
        serviceImage.push('latest')
        nodeServiceImage.push('latest')
      }
    }

    // remove images to save space
    sh "docker rmi ${javaImage.id}"
    sh "docker rmi ${serviceImage.id}"
    sh "docker rmi ${nodeServiceImage.id}"
  }
}
