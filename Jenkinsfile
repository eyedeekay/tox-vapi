pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'make clean'
                archiveArtifacts artifacts: 'bin', fingerprint: true
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh 'make deb-pkg'
            }
        }
    }
}
