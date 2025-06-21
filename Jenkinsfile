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
                         def fullImageName = "${registry}:${env.BUILD_NUMBER}" // Sử dụng GString để nối chuỗi an toàn
                        // Hoặc đơn giản hơn:
                        // def fullImageName = registry + ":" + env.BUILD_NUMBER

                        // Bước 2: Build image và chỉ định nền tảng
                        dockerImage = docker.build(fullImageName, "--platform linux/amd64 .") // <-- Sửa lại dòng này
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