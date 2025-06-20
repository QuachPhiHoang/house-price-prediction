pipeline {
    agent any

    options{
        // Max number of build logs to keep and days to keep
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '5'))
        // Enable timestamp at each job in the pipeline
        timestamps()
    }

    environment{
        registry = 'hoangquach1908/house-price-prediction-api'
        registryCredential = 'dockerhub'      
    }

    stages {
        stage('Test') {
            agent {
                docker {
                    image 'python:3.8' 
                    reuseNode true 
                }
            }
            steps {
                echo 'Testing model correctness..'
                dir('python_app') {
                sh 'pip install -r requirements.txt && pytest'
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    echo 'Building image for deployment..'
                    dir('python_app') {
                        dockerImage = docker.build registry + ":$BUILD_NUMBER" + .
                    }
                    echo 'Pushing image to dockerhub..'
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying models..'
                echo 'Running a script to trigger pull and start a docker container'
            }
        }
    }
}