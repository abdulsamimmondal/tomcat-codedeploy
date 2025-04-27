pipeline {
    agent any
     environment {
    DOCKERHUB_TOKEN = credentials('docker-hub-credential')
  }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
 
        stage('Build and Test') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        echo "Building, testing, and pushing Docker image on development branch"
                        sh 'mvn clean install'
                        sh 'mvn test'
                         sh "echo ${DOCKERHUB_TOKEN} | docker login -u akashchandran --password-stdin"
                            sh 'docker build -t akashchandran/my-java-webapp:latest .'
                            sh 'docker push akashchandran/my-java-webapp:latest'
                        }
                    }
                }
            }
	stage('Deployment'){
		steps{
 
			sh 'kubectl apply -f deployment.yaml'
			sh 'kubectl apply -f service.yaml'
		}
        }
        }
    }
