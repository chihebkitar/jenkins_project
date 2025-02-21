@Library('chiheb-library') _ 

pipeline {
    agent any

    environment {
        IMAGE_NAME = 'webapp'
        IMAGE_TAG = 'V1'
        DOCKER_PASSWORD = credentials('docker-password')
        DOCKER_USERNAME = 'kitarchiheb'
        HOST_PORT = 80
        CONTAINER_PORT = 80
        IP_DOCKER = '172.17.0.1'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh '''
                        docker build --no-cache -t $IMAGE_NAME:$IMAGE_TAG .
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh '''
                        docker run -d -p $HOST_PORT:$CONTAINER_PORT --name $IMAGE_NAME $IMAGE_NAME:$IMAGE_TAG
                        sleep 5
                        curl -I http://$IP_DOCKER
                        docker stop $IMAGE_NAME
                        docker rm $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Release') {
            steps {
                script {
                    sh '''
                        docker tag $IMAGE_NAME:$IMAGE_TAG $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy Review') {
            environment {
                SERVER_IP = '15.237.217.111'
                SERVER_USERNAME = 'ubuntu'
            }
            steps {
                script {
                    timeout(time: 30, unit: "MINUTES") {
                        input message: "Deploy to Review environment?", ok: 'Yes'
                    }
                    sshagent(['key-pair']) {
                        sh '''
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker rm -f $IMAGE_NAME || echo 'Deleted existing container'"
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker pull $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker run -d -p $HOST_PORT:$CONTAINER_PORT --name $IMAGE_NAME $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                            sleep 5
                            curl -I http://$SERVER_IP:$HOST_PORT
                        '''
                    }
                }
            }
        }

        stage('Deploy Staging') {
            environment {
                SERVER_IP = '13.38.24.11'
                SERVER_USERNAME = 'ubuntu'
            }
            steps {
                script {
                    timeout(time: 30, unit: "MINUTES") {
                        input message: "Deploy to Staging environment?", ok: 'Yes'
                    }
                    sshagent(['key-pair']) {
                        sh '''
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker rm -f $IMAGE_NAME || echo 'Deleted existing container'"
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker pull $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker run -d -p $HOST_PORT:$CONTAINER_PORT --name $IMAGE_NAME $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                            sleep 5
                            curl -I http://$SERVER_IP:$HOST_PORT
                        '''
                    }
                }
            }
        }

        stage('Deploy Prod') {
            environment {
                SERVER_IP = '13.38.11.133'
                SERVER_USERNAME = 'ubuntu'
            }
            steps {
                script {
                    timeout(time: 30, unit: "MINUTES") {
                        input message: "Deploy to Production environment?", ok: 'Yes'
                    }
                    sshagent(['key-pair']) {
                        sh '''
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker rm -f $IMAGE_NAME || echo 'Deleted existing container'"
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker pull $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                            ssh -o StrictHostKeyChecking=no -l $SERVER_USERNAME $SERVER_IP "docker run -d -p $HOST_PORT:$CONTAINER_PORT --name $IMAGE_NAME $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                            sleep 5
                            curl -I http://$SERVER_IP:$HOST_PORT
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                slackNotifier currentBuild.result
            }
        }
    }
}
