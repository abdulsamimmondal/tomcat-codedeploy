pipeline {
    agent any

    environment {
        image = 'akashchandran/java-hello-multi'
    }

    stages {
        stage('Maven Clean and Package') {
            when {
                branch 'main'
            }
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Run Unit Tests') {
            when {
                branch 'feature'
            }
            steps {
                sh 'mvn test'
            }
        }

        stage('Docker Build and Push') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh "docker build -t ${image} ."
                    withCredentials([usernamePassword(credentialsId: 'Dockerhub', usernameVariable: 'username', passwordVariable: 'password')]) {
                        sh 'docker login -u "$username" -p "$password"'
                        sh "docker push ${image}"
                    }
                }
            }
        }
    }
}
