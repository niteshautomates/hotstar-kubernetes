pipeline {
  agent any
  tools {
    jdk 'jdk'
    nodejs 'node'
  }
  environment {
    SCANNER_HOME = tool 'sonar-scanner'
  }
  stages {
    stage('Git Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/niteshtheqa/hotstar-kubernetes.git'
      }
    }
    stage("Sonarqube Analysis ") {
      steps {
        withSonarQubeEnv('sonar-scanner') {
          sh ''
          ' 
          $SCANNER_HOME / bin / sonar - scanner - Dsonar.projectName = Hotstar\ -
            Dsonar.projectKey = Hotstar ''
          '        

        }
      }
    }
    stage("Quality Gate") {
      steps {
        script {
          waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
        }
      }
    }
    /* stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit --nvdApiKey a58f03a4-2cf0-4db7-8abc-a107fe349435', odcInstallation: 'dc'
                dependencyCheckPublisher pattern: '**/
    /*dependency-check-report.xml' 
           }
        } */

    stage("Install Dependencies") {
      steps {
        sh 'npm install'
      }
    }
    stage("Trivy File Scan") {
      steps {
        sh 'trivy fs -f table -o fs_scan_report.txt .'
      }
    }
    stage("Docker Build & Push") {
      steps {
        script {
          // This step should not normally be used in your script. Consult the inline help for details.
          withDockerRegistry(credentialsId: 'docker-token', toolName: 'docker') {
            sh "docker build -t hotstar ."
            sh "docker tag hotstar nitesh2611/hotstar:latest "
            sh "docker push nitesh2611/hotstar:latest "
          }
        }
      }
    }
    stage("Trivy Image Scan") {
      steps {
        sh "trivy image -f table -o img_scan_report.txt nitesh2611/hotstar:latest"
      }
    }
    stage('Deploy to container') {
      steps {
        sh 'docker run -d --name hotstar -p 3000:3000 nitesh2611/hotstar:latest'
      }
    }
  }
}
