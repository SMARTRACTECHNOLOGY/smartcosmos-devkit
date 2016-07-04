node {

  stage 'checkout'
  checkout scm

  stage 'docker build'
  dir('docker') {
    def javaImage = docker.build "smartcosmos/java", "java"
    def serviceImage = docker.build "smartcosmos/service", "service"
  }
}
