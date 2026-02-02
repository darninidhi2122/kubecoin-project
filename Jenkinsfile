pipeline {
  agent any

  environment {
    DOCKERHUB_USER = "darninidhi2122"
    TAG = ""
    NAMESPACE = ""
  }

  stages {

    stage('Detect Environment') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            env.TAG = 'dev'
            env.NAMESPACE = 'dev'
          } else if (env.BRANCH_NAME == 'test') {
            env.TAG = 'testing'
            env.NAMESPACE = 'testing'
          } else if (env.BRANCH_NAME == 'prod') {
            env.TAG = 'production'
            env.NAMESPACE = 'production'
          }
        }
      }
    }

    stage('Build Docker Images') {
      steps {
        sh """
        docker build -t $DOCKERHUB_USER/kubecoin-frontend:$TAG frontend/
        docker build -t $DOCKERHUB_USER/kubecoin-backend:$TAG backend/
        """
      }
    }

    stage('Push Images to DockerHub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'USER',
          passwordVariable: 'PASS'
        )]) {
          sh """
          docker login -u $USER -p $PASS
          docker push $DOCKERHUB_USER/kubecoin-frontend:${TAG}
          docker push $DOCKERHUB_USER/kubecoin-backend:${TAG}
          """
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh """
        kubectl apply -f assignment/$TAG/ -n $NAMESPACE
        """
      }
    }
  }
}
