pipeline {
    
	agent any
    
    environment {
        registryCredential = 'ecr:us-east-1:awscreds'
        backendRegistry = '807373741966.dkr.ecr.us-east-1.amazonaws.com/3tier_backend'
        frontendRegistry = '807373741966.dkr.ecr.us-east-1.amazonaws.com/3tier_frontend'
        ecr_Registry = 'https://807373741966.dkr.ecr.us-east-1.amazonaws.com'
    }
	
    stages{

        stage ('Build Backend Image') {
		      steps {
			      script {
                dockerImageBackend = docker.build( backendRegistry + ":$BUILD_NUMBER", "./backend/")
              }
            }
        }

        stage('Upload Backend Image') {
          steps{
            script {
              docker. withRegistry( ecr_Registry, registryCredential ) {
                dockerImageBackend.push("$BUILD_NUMBER")
              }
            }
          }
        }

        stage ('Build Frontend Image') {
		      steps {
			      script {
                dockerImageFrontend = docker.build( frontendRegistry + ":$BUILD_NUMBER", "./frontend/")
              }
            }
        }

        stage('Upload DB Image') {
          steps{
            script {
              docker. withRegistry( ecr_Registry, registryCredential ) {
                dockerImageFrontend.push("$BUILD_NUMBER")
              }
            }
          }
        }

        stage('Remove Images from Jenkins'){
          steps{
            sh 'docker system prune -af'
          }
        }
    }
}