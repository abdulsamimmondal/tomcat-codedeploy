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
                    sh "mvn clean verify sonar:sonar -Dsonar.projectKey=Java-application -Dsonar.projectName='Java-application' -Dsonar.host.url=http://34.239.141.95:9000 -Dsonar.token=sqp_b7670fd0beb1d6301814e0afda996b6703c7e087"
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
