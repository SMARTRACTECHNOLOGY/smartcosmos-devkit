node {

  stage 'checkout'
  checkout scm

  dir('docker') {
    stage 'docker build smartcosmos/java'
    def javaImage = docker.build "smartcosmos/java", "java"
    stage 'docker build smartcosmos/service'
    def serviceImage = docker.build "smartcosmos/service", "service"
  }
}
