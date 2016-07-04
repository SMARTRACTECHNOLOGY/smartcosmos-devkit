node {

  stage 'checkout'
  checkout scm

  stage 'docker build'
  dir('docker') {
    def image = docker.build "smartcosmos/java", "java"
    def image = docker.build "smartcosmos/service", "service"
  }
}
