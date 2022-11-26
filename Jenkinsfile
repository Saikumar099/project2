pipeline {
    agent none
      tools{
       git 'Git'
       maven 'maven3.8.6'
      }
      environment {     
              def DOCKERHUB_CREDENTIALS=credentials('docker-hub') 
              AWS_ACCOUNT_ID="948406862378"
              AWS_DEFAULT_REGION="us-west-1"
              IMAGE_REPO_NAME="project2"
              IMAGE_TAG="latest"
              REPOSITORY_URI = "948406862378.dkr.ecr.us-west-1.amazonaws.com/project2"
        } 
       stages{
           stage('checkout code') {
               agent {
                    label 'master'
               }
               steps{
               checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'Guthub', url: 'https://github.com/Saikumar099/project2.git']]])  
               stash 'source'
               }
           }
            stage('maven build') {
               agent {
                    label 'master'
               }
               steps{
                     sh 'mvn package'
                }
           }
           stage('sonarqube report') {
               agent {
                    label 'Docker Server'
               }
               environment{
                   scannerHome = tool 'SonarQubeScanner'
               }
               steps{
                    unstash 'source'
                    withSonarQubeEnv('sonarqube-9.1') { 
                        // sh "${"SonarQubeScanner"}/bin/sonar-scanner" 
                         // sh '''$scannerHome/bin/sonar-scanner 
                        //-Dsonar.host.url=http://54.193.191.66:9000 
                        //-Dproject.settings=sonar-project.properties
                        //-Dsonar.projectKey=project-demo 
                        //-Dsonar.projectName=project-demo 
                        //-Dsonar.java.binaries=target/classes'''
                       sh 'mvn clean install sonar:sonar -Dsonar.host.url=http://54.193.191.66:9000 -Dproject.settings=sonar-project.properties -Dsonar.projectKey=project2 -Dsonar.projectName=project2 || true'
                    }
                }
           }
          stage('upload artifacts to nexus') {
               agent {
                    label 'Docker Server'
                }
              steps{
                 nexusArtifactUploader artifacts: [[artifactId: 'maven-web-application', 
                                       classifier: '', 
                                       file: 'target/maven-web-application.war', 
                                       type: 'war']], 
                                       credentialsId: 'nexus', 
                                       groupId: 'com.mt', 
                                       nexusUrl: '54.193.191.66:8081/', 
                                       nexusVersion: 'nexus3', 
                                       protocol: 'http', 
                                       repository: 'project2', 
                                      version: '1.0'
               } 
           }
           stage('creating tomcat image with webapp') {
              agent {
                    label 'Docker Server'
              }
               steps{
                     //sh 'docker build -t saikumar099/java-web-app:$BUILD_NUMBER .'   //for dockerhub
		             sh 'docker build -t project2 .'   
              }
           }
         stage('pushing image to ECR') {
             agent {
                 label 'Docker Server'
             }
	        steps{
		       script{
		          sh 'aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 948406862378.dkr.ecr.us-west-1.amazonaws.com'
		        // sh “aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com”
		        // sh 'docker build -t ecr-demo .'
                 //sh 'docker tag ecr-demo:latest 948406862378.dkr.ecr.us-west-1.amazonaws.com/ecr-demo:latest'
                 //sh 'docker tag ecr-demo:latest saikumar099/java-web-app:$BUILD_NUMBER'
                sh 'docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG'
			     //sh 'docker push 948406862378.dkr.ecr.us-west-1.amazonaws.com/ecr-demo:latest'
                sh 'docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}'
			    }
		    }
	     }  	  
           /*stage('pushing image to dockerhub registry') {
              agent {
                    label 'Docker Server'
              }
                steps{  
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                		
	                 echo 'Login Completed'  
                  // withDockerRegistry(credentialsId: 'docker-hub', url: 'https://hub.docker.com/repository/docker/saikumar099/java-web-app') {
                     sh 'docker push saikumar099/java-web-app:$BUILD_NUMBER'
                     echo 'Push Image Completed'
                     //}  
                  }
             } */
            stage('deploying image to k8s') {
                agent {
                    label 'Docker Server'
                }
                steps{
                    sh '''
                    aws eks --region us-west-1 update-kubeconfig --name eks-cluster
                    kubectl apply -f mavenwebappdeployment.yml -n sample-ns
                    '''
                }
            }
         }
       
       }
     
