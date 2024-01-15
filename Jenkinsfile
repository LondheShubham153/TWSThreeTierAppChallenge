pipeline {
    
	agent any
    
    environment {
        registryCredential = 'ecr:us-east-1:awscreds'
        backend_registry = '807373741966.dkr.ecr.us-east-1.amazonaws.com/3tier_backend'
        frontend_registry = '807373741966.dkr.ecr.us-east-1.amazonaws.com/3tier_frontend'
        ecr_registry = 'https://807373741966.dkr.ecr.us-east-1.amazonaws.com'
    }
	
    stages{

        stage ('Build Backend Image') {
		      steps {
			      script {
                dockerImageBackend = docker.build( backend_registry + ":$BUILD_NUMBER", "./backend/")
              }
            }
        }

        stage('Upload Backend Image') {
          steps{
            script {
              docker. withRegistry( ecr_registry, registryCredential ) {
                dockerImageBackend.push("$BUILD_NUMBER")
              }
            }
          }
        }

        stage ('Build Frontend Image') {
		      steps {
			      script {
                dockerImageFrontend = docker.build( frontend_registry + ":$BUILD_NUMBER", "./frontend/")
              }
            }
        }

        stage('Upload Frontend Image') {
          steps{
            script {
              docker. withRegistry( ecr_registry, registryCredential ) {
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

    //     stage('Update Manifest') {
    //       steps {
    //         script {
    //         // echo "sed command: sed -i 's/{frontend_registry}\\\\:${BUILD_NUMBER}/807373741966.dkr.ecr.us-east-1.amazonaws.com\\/3tier_frontend:\\\$(echo \$BUILD_NUMBER | tr A-Z a-z)/g'"
    //           println "sed command: sed -i 's/{frontend_registry}\\\\:${BUILD_NUMBER}/807373741966.dkr.ecr.us-east-1.amazonaws.com\\/3tier_frontend:\\\$(echo \${BUILD_NUMBER} | tr A-Z a-z)/g'"
    //         //  sh "sed -i 's/{frontend_registry}\\\\:${BUILD_NUMBER}/807373741966.dkr.ecr.us-east-1.amazonaws.com\\/3tier_frontend:\\\$(echo \$BUILD_NUMBER | tr A-Z a-z)/g' k8s_manifests/frontend/frontend-deployment.yaml"
    //         //  sh "sed -i 's/{backend_registry}\\\\:${BUILD_NUMBER}/807373741966.dkr.ecr.us-east-1.amazonaws.com\\/3tier_backend:\\\$(echo \$BUILD_NUMBER | tr A-Z a-z)/g' k8s_manifests/backend/backend-deployment.yaml"
    //     }
    //   }
    // }

        stage('Deploy to EKS Cluster') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'demo', contextName: '', credentialsId: 'k8s-token', namespace: 'workshop', restrictKubeConfigAccess: false, serverUrl: 'https://77ECB14AE268693EC968CA3A5341FD14.gr7.us-east-1.eks.amazonaws.com') {
    			      echo 'deploying to eks-cluster...'
	                sh 'kubectl apply -f k8s_manifests/mongo/'
                  sh 'envsubst < k8s_manifests/backend/backend-deployment.yaml | kubectl apply -f -'
                  sh 'envsubst < k8s_manifests/frontend/frontend-deployment.yaml | kubectl apply -f -'
                  // sh 'kubectl apply -f k8s_manifests/full_stack_lb.yaml'
		            }
            }
        }
    }
}