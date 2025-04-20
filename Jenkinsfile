pipeline {
    agent any

    tools {
        maven 'Maven'
      }

    environment {
            DOCKERHUB_CREDENTIALS=credentials('jihen')
            DOCKER_IMAGE = 'jihen501/springboot-app'
    }

    stages {

        stage('Préparer la version') {
        steps {
            script {
                VERSION = new Date().format('yyyyMMdd-HHmm')
                env.VERSION = VERSION  // important pour l'utiliser dans d'autres étapes
            }
        }
    }
        stage('Cloner le dépôt') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                 echo 'Building...'
                sh 'mvn clean install'
                //	The sh step invokes the mvn clean install command and will only continue if a zero exit code is returned by the command. Any non-zero exit code will fail the Pipeline.
            }
        }

        stage('Tests') {
            steps {
                sh 'mvn test'
                //	The sh step invokes the mvn test command and will only continue if a zero exit code is returned by the command. Any non-zero exit code will fail the Pipeline.
            }
        }

        stage('Construire l\'image Docker') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${VERSION}")
                    //	Build the Docker image using the Dockerfile in the root of the project. The image will be tagged with the name and version defined in the environment variables.
                }
            }
        }
        
        stage('Push Docker image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push("${VERSION}")
                        dockerImage.push("latest") 
                        //	Push the Docker image to Docker Hub using the credentials defined in Jenkins.
                    }
                }
            }

        }


 }
  post {
        success {
            echo "Pipeline terminé avec succès weey !"
        }
        failure {
            echo "Le pipeline a échoué."
        }
    }
 }
