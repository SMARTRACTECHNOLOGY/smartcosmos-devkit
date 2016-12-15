node {

  stage 'checkout'
  checkout scm

  dir('docker') {
    def tag = (env.BRANCH_NAME == 'master') ? env.BUILD_NUMBER : "snapshot-${env.BUILD_NUMBER}"

    stage 'docker build smartcosmos/node-service'
    def nodeServiceImage = docker.build "smartcosmos/node-service:${tag}", "node-service"

    if (env.BRANCH_NAME == 'master') {
      stage 'push images'

      docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
        nodeServiceImage.push('latest')
      }
    }

    // remove images to save space
    sh "docker rmi ${nodeServiceImage.id}"
  }
}
