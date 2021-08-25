pipeline {
    agent any
  
    stages {
        stage('Clone') { 
            steps {
                git branch: 'main', url: 'https://github.com/SiwatINC/humhub'
            }
        } 
        stage('Build Docker Image') {
            steps {
                script {
                    image = docker.build("siwatinc/humhub:latest")
                }
            }
        }
        stage('Publish Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://ghcr.io/v2") {
                        image.push()
                    }
                }
            }
        }
    }
}