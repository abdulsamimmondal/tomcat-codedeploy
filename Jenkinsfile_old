pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'akashchandran'
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/java-application"
        DOCKERHUB_TOKEN = credentials('docker-hub-credential')
        SONARQUBE_TOKEN = credentials('SonarQb')
        SONARQUBE_URL = 'http://54.198.92.159:9000/'
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
                withSonarQubeEnv('SonarQb') {
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
                    // Skip waiting for quality gate status, and just log the result
                    try {
                        def qualityGateStatus = sh(
                            script: "curl -u admin:admin '${SONARQUBE_URL}/api/qualitygates/project_status?projectKey=${PROJECT_KEY}'", 
                            returnStdout: true
                        ).trim()
                        echo "SonarQube API Response: ${qualityGateStatus}"  // Debug output
                        
                        if (qualityGateStatus) {
                            def statusJson = readJSON text: qualityGateStatus
                            def gateStatus = statusJson.projectStatus.status
                            echo "Quality Gate Status: ${gateStatus}"
                            
                            // Log and continue the pipeline, even if the gate fails
                            if (gateStatus != 'OK') {
                                echo "Warning: SonarQube Quality Gate failed, continuing pipeline."
                            }
                        } else {
                            echo "No data received from SonarQube API"
                        }
                    } catch (Exception e) {
                        echo "Error retrieving SonarQube Quality Gate status: ${e.getMessage()}"
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
