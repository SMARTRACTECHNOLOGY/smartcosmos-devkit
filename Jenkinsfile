node {

  stage 'checkout'
  checkout scm

  dir('docker') {
    stage 'docker build smartcosmos/java'
    def tag = (env.BRANCH_NAME == 'master') ? env.BUILD_NUMBER : "snapshot-${env.BUILD_NUMBER}"

    docker.withRegistry('https://docker.io/', 'dockerhub-credentials') {
      def javaImage = docker.build "smartcosmos/java:${tag}", "java"
      stage 'docker build smartcosmos/service'
      def serviceImage = docker.build "smartcosmos/service:${tag}", "service"

      if (env.BRANCH_NAME == 'master') {
        stage 'push images'

          javaImage.push('latest')
          serviceImage.push('latest')
      } else {
        sh "docker rmi ${javaImage.id}"
        sh "docker rmi ${serviceImage.id}"
      }
    }
  }
}
