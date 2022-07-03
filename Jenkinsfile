pipeline {
    agent {
        node {
            label 'ubuntu-2004'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'flutter build apk'
                googleStorageUpload(pattern: '/tmp/workspace/clawtech_logistica_app/build/app/outputs/apk/release/app-release.apk', bucket: 'gs://clawtech-logistica-proyecto-jenkins-artifacts/$JOB_NAME/$BUILD_NUMBER', credentialsId: 'gcloud')
            }
        }
        stage('Test') {
            steps {
                sh 'flutter test'
            }
        }
    }
   
}
