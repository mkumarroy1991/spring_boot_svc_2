node{
    
    def MAVEN_HOME = '/opt/maven/bin'
    def mail_to = 'vinaylodhi19081999@gmail.com'
    def mail_from = 'vinaylodhi1908@gmail.com'
   def build_tag_format = "--pretty='%h'"
    def build_tag
    
   
       
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
                url: 'https://github.com/VinayLodhi/spring_boot_svc_2.git'
            
            // Git hash Code ->
           
           build_tag = sh( 
               script: "git log ${build_tag_format} -1",
               returnStdout: true
               ).trim()
               
            
            
                    
        }
            
        stage('Junit'){
                
            sh "${MAVEN_HOME}/mvn clean test"
         
                
        }

        stage('SonarQube'){

            withSonarQubeEnv(credentialsId: 'sonar-key', installationName: 'sonar-server') {

                //sh "${MAVEN_HOME}/mvn -B clean verify sonar:sonar"

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
  
            sh "docker build -t vinay1908/spring-app-2:${build_tag} ."

        }
        
        stage('Push to DockerHub'){

            withCredentials([usernamePassword(credentialsId: 'DHCred', passwordVariable: 'DHPASS', usernameVariable: 'DHUSER')]) {
                 
                sh "docker login -u ${DHUSER} -p ${DHPASS}"
                sh "docker push vinay1908/spring-app-2:${build_tag}"
                }
        }

            
            
        stage('Deploy to Kubernetes') {
             
            withKubeConfig([credentialsId: 'k', serverUrl: 'https://172.31.31.194:6443']) {
                //sh "kubectl set image deployment/app-1 spring-con1=vinay1908/spring-app-1:${build_tag} --record"
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
                }
        }  

        stage('Post-build Section') {
            
            emailext ( attachLog: true, 
                subject: "Jenkins Job: '${env.JOB_NAME}' has completed",
                body: "Job :'${env.JOB_NAME}' \n Build No. :'${env.BUILD_NUMBER}' \n Build Url :'${env.BUILD_URL}'",
                to: "${mail_to}",
                from: "${mail_from}"
            )
                
        } 

    


}
