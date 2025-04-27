pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'akashchandran'
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/java-application"
        DOCKERHUB_TOKEN = credentials('docker-hub-credential')
        SONARQUBE_TOKEN = credentials('SonarQb')
        SONARQUBE_URL = 'http://34.239.141.95:9000'
        PROJECT_KEY = 'Java-application'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    mvn clean install
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    script {
                        sh """
                            mvn clean verify sonar:sonar \
                                -Dsonar.projectKey=${PROJECT_KEY} \
                                -Dsonar.projectName='Java-application' \
                                -Dsonar.host.url=${SONARQUBE_URL} \
                                -Dsonar.token=${SONARQUBE_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                script {
                    // Wait for quality gate to pass
                    def qualityGateStatus = ''
                    timeout(time: 5, unit: 'MINUTES') {
                        waitUntil {
                            qualityGateStatus = sh(
                                script: "curl -u admin:admin '${SONARQUBE_URL}/api/qualitygates/project_status?projectKey=${PROJECT_KEY}'", 
                                returnStdout: true
                            ).trim()
                            def statusJson = readJSON text: qualityGateStatus
                            def gateStatus = statusJson.projectStatus.status
                            return gateStatus == 'OK'
                        }
                    }
                    if (qualityGateStatus.contains('ERROR')) {
                        error "SonarQube Quality Gate failed, aborting pipeline."
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                sh """
                    echo ${DOCKERHUB_TOKEN} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                    docker build -t ${DOCKER_IMAGE} .
                    docker push ${DOCKER_IMAGE}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                branch 'main'
            }
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
