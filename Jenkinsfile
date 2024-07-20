pipeline{

    agent any
    
    tools{
        maven "maventool"
    }

    environment{
           APP_NAME = "springboot-docker-cicd"
           RELEASE_NO= "1.0.0"
           DOCKER_USER= "javaexpress"
           IMAGE_NAME= "${DOCKER_USER}"+"/"+"${APP_NAME}"
           IMAGE_TAG= "${RELEASE_NO}-${BUILD_NUMBER}"
    }

    stages{

        stage("SCM checkout"){
            steps{
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/javatechie-devops/jenkins-ci-cd.git']])
            }
        }

        stage("Build Process"){
            steps{
                script{
                    sh 'mvn clean install'
                }
            }
        }

        stage("Build Image"){
            steps{
                script{
                    sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }

        stage("Deploy Image to Hub"){
            steps{
                 withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'DOCKER_HUB')]) {
                 sh 'docker login -u javaexpress -p ${DOCKER_HUB}'
                 sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
                }
            }
        }
        
        stage("Deploy to Kubernetes" )
		{
			steps {
				sh """
				    sed -i "s|image: ''|image: '${IMAGE_NAME}:${IMAGE_TAG}'|g" k8s-app.yaml
		   		   """
				sh 'kubectl apply -f k8s-app.yaml'
		}
}
    }
}
