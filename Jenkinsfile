pipeline{
    agent any
    tools{
        maven "M3"
    }
    stages{
        stage('Prepare'){
            steps{
                script{
                    Date date = new Date()
                    env.NAME = date.format("yyyy-MM-dd")
                }
            }
            post{
                always{
                    script{
                        currentBuild.displayName = "spring-app-${NAME}"
                    }
                }
            }
        }

        stage('Build app'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'WipeWorkspace'],[$class: 'LocalBranch', localBranch: "**"]], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Lockhart01/springboot-test.git']]])
                sh 'cd demo && mvn clean package'
                script{
                    env.VERSION = sh(script: 'find ./demo/target -name "*.jar" | cut -d"/" -f4 | cut -d"." -f1', , returnStdout: true).trim()
                }
                stash includes: '', name: 'app', allowEmpty: false
            }
        }
        stage('Build docker image'){
            agent{
                label 'docker'
            }
            
            steps{
                sh "echo ${VERSION}"
                unstash 'app'
                withCredentials([usernamePassword(credentialsId: 'Dockerhub', passwordVariable: 'DPASSWORD', usernameVariable: 'DUSER')]) {
                    sh 'chmod +x deploy.sh && ./deploy.sh'
                }
                stash includes: 'demo/target/*.jar', name: 'artifact', allowEmpty: false
            }

        }
        stage('storage jar'){
            steps{
                unstash 'artifact'
                sh 'ls -al'
                nexusArtifactUploader(
                    nexusVersion: "nexus3",
                    protocol: "http",
                    nexusUrl: "10.5.0.9:8081",
                    groupId: '',
                    version: "${VERSION}",
                    repository: "spring-app",
                    credentialsId: "nexus-creds",
                    artifacts: [
                        [artifactId: "${VERSION}",
                        classifier: '',
                        file: "${WORKSPACE}/demo/target/${VERSION}.jar",
                        type: 'jar']
                    ]
                );		
            }
        }
        
    }
}