pipeline {
    agent any

    environment {
        DOCKERHUB_TOKEN = credentials('docker-hub-credential')
        // Ensure the SonarQube server name matches the one configured in Jenkins
        SONARQUBE_ENV = 'SonarQb'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh 'mvn clean verify sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build and Test') {
            when {
                branch 'main'
            }
            steps {
                sh 'mvn clean install'
                sh 'mvn test'
                sh "echo ${DOCKERHUB_TOKEN} | docker login -u akashchandran --password-stdin"
                sh 'docker build -t akashchandran/my-java-webapp:latest .'
                sh 'docker push akashchandran/my-java-webapp:latest'
            }
        }

        stage('Deployment') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
}
