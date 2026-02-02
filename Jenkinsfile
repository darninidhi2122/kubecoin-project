pipeline {
  agent any

  environment {
    DOCKERHUB_USER = "darninidhi2122"
    TAG = ""
    NAMESPACE = ""
  }

  stages {

    /* -----------------------------
       Detect Environment from Branch
       ----------------------------- */
    stage('Detect Environment') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            env.TAG = 'dev'
            env.NAMESPACE = 'dev'
          }
          else if (env.BRANCH_NAME == 'test') {
            env.TAG = 'testing'
            env.NAMESPACE = 'testing'
          }
          else if (env.BRANCH_NAME == 'prod') {
            env.TAG = 'production'
            env.NAMESPACE = 'production'
          }
          else {
            error "Unsupported branch: ${env.BRANCH_NAME}. Allowed: dev, test, main"
          }
        }
      }
    }

    /* -----------------------------
       Build Docker Images
       ----------------------------- */
    stage('Build Docker Images') {
      steps {
        sh """
        echo "Building images for environment: ${env.TAG}"

        docker build -t ${DOCKERHUB_USER}/kubecoin-frontend:${env.TAG} frontend/
        docker build -t ${DOCKERHUB_USER}/kubecoin-backend:${env.TAG} backend/
        """
      }
    }

    /* -----------------------------
       Push Images to Docker Hub
       ----------------------------- */
    stage('Push Images to DockerHub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh """
          echo "Logging in to Docker Hub"
          echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

          echo "Pushing images"
          docker push ${DOCKERHUB_USER}/kubecoin-frontend:${env.TAG}
          docker push ${DOCKERHUB_USER}/kubecoin-backend:${env.TAG}
          """
        }
      }
    }

    /* -----------------------------
       Deploy to Kubernetes
       ----------------------------- */
    stage('Deploy to Kubernetes') {
      steps {
        sh """
        echo "Deploying to namespace: ${env.NAMESPACE}"

        kubectl apply -f assignment/${env.TAG}/ -n ${env.NAMESPACE}
        """
      }
    }
  }

  /* -----------------------------
     Post Actions
     ----------------------------- */
  post {
    success {
      echo "Pipeline completed successfully for branch: ${env.BRANCH_NAME}"
    }
    failure {
      echo "Pipeline failed for branch: ${env.BRANCH_NAME}"
    }
  }
}
