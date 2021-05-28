node{
    
    def MAVEN_HOME = '/opt/maven/bin'
    def mail_to = 'vinaylodhi1908@gmail.com'
    try{
        stage('Cleaning the Workspace') {
            sh """
                pwd
                echo "cleaning workspace"
            """
            cleanWs()
                
        }
        stage('Git Checkout') {
                
            git branch: 'dev',
                credentialsId: 'git_cred',
                url: 'https://github.com/VinayLodhi/SpringBoot.git'
                    
        }
            
        stage('Junit'){
                
            sh "${MAVEN_HOME}/mvn clean test"
                
        }

        stage('SonarQube'){

            withSonarQubeEnv(credentialsId: 'sonar-key', installationName: 'sonar-server') {

                sh "${MAVEN_HOME}/mvn -B clean verify sonar-scanner:sonar"

            }    
            
                
        }
            
        stage('mvn build'){
                
            sh "${MAVEN_HOME}/mvn clean package -DskipTests"
                
        }
            
        stage('Uploading Artifacts to Artifactory'){
            /*def server = Artifactory.server('art-dev')
                def uploadSpec = """{
                                "files": [
                                    {
                                    "pattern": "/webapp/target/webapp.war",
                                    "target": "sample-app/webapp/"
                                    }
                                ]
                                }"""
            server.upload(uploadSpec)*/
        }
            
        stage('Docker Build'){
                
            sh "docker build -t vinay1908/spring-boot:v1 ."

        }
        
        stage('Push to DockerHub'){

            withCredentials([usernamePassword(credentialsId: 'DHCred', passwordVariable: 'DHPASS', usernameVariable: 'DHUSER')]) {
        
                sh "docker login -u ${DHUSER} -p ${DHPASS}"
                sh "docker push vinay1908/spring-boot:v1"
                }
        }

            
            
        stage('Deploy to Kubernetes') {
            
            withKubeConfig([credentialsId: 'k', serverUrl: 'https://172.31.31.194:6443']) {
            sh 'kubectl apply -f deployment.yaml'
            sh 'kubectl apply -f service.yaml'
            }
                
        }  

        stage('Post-build Section') {
            
            emailext ( attachLog: true, 
                subject: "Jenkins Job: '${env.JOB_NAME}' has completed",
                body: "Job :'${env.JOB_NAME}' \n Build No. :'${env.BUILD_NUMBER}' \n Build Url :'${env.BUILD_URL}'",
                to: "${mail_to}"
            )
                
        } 

    }catch(Exception exp){
        
        emailext ( attachLog: true, 
        subject: "Jenkins Job: '${env.JOB_NAME}' has failed",
        body: "Job :'${env.JOB_NAME}' \n Build No. :'${env.BUILD_NUMBER}' \n Build Url :'${env.BUILD_URL}'",
        to: "${mail_to}"
        )

    }


}
