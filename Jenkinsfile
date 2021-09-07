node{
    
    def MAVEN_HOME = '/opt/maven/bin'
    def mail_to = 'mkroy1501@gmail.com'
    def mail_from = 'mkroy1501@gmail.com'
    def build_tag_format = "--pretty='%h'"
    def build_tag
    
   
    try{
        
        stage('Cleaning the Workspace') {
            sh """
                pwd
                echo "cleaning workspace"
            """
            cleanWs()
                //clean
        }
        stage('Git Checkout') {
                
            git branch: 'dev',
                credentialsId: 'Manish_ID',
                url: 'https://github.com/mkumarroy1991/spring_boot_svc_2.git'
            
            // Git hash Code ->
           
           build_tag = sh( 
               script: "git log ${build_tag_format} -1",
               returnStdout: true
               ).trim()
                   
        }
            
        stage('Junit'){
                sh "/usr/bin/mvn clean test"
            //sh "${MAVEN_HOME}/mvn clean test"
         
                
        }

       // stage('SonarQube'){

       //     withSonarQubeEnv(credentialsId: 'sonar-token', installationName: 'sonar-server') {

       //         sh "${MAVEN_HOME}/mvn -B -f pom.xml -Dsonar.projectName=spring-app-2 clean verify sonar:sonar"

        //    }    
            
                
       // }
            
        stage('mvn build'){
                
            sh "/usr/bin/mvn clean package -DskipTests"
                
        }
        
        stage('Uploading Artifacts to Artifactory'){
            
            def server = Artifactory.server 'jfrog-server'
                def uploadSpec = """{
                                "files": [
                                    {
                                    "pattern": "webapp/target/webapp.war",
                                    "target": "spring-boot-svc-2/com/mycompany/${build_tag}/"
                                    }
                                ]
                                }"""
            server.upload(uploadSpec)
             
        }
            
        stage('Docker Build'){
  
            sh "docker build -t manishroy1710/spring-app-2:${build_tag} ."
            //sh "docker build -t manishroy1710/spring-app-1:v1 ."

        }
        
        stage('Push to DockerHub'){

            withCredentials([usernamePassword(credentialsId: 'Manish_DH', passwordVariable: 'DHPASS', usernameVariable: 'DHUSER')]) {
                 
                sh "docker login -u ${DHUSER} -p ${DHPASS}"
                sh "docker push manishroy1710/spring-app-2:${build_tag}"
                }
        }

            
            
        stage('Deploy to Kubernetes') {
             
            withKubeConfig([credentialsId: 'kube_config', serverUrl: 'https://172.31.27.97:6443']) {
                sh "kubectl set image deployment/app-2 spring-con2=manishroy1710/spring-app-2:${build_tag} --record"
                //sh 'kubectl apply -f deployment.yaml'
                //sh 'kubectl apply -f service.yaml'
                }
            /*
            kubernetesDeploy(
                    configs: 'deployment.yaml',
                    kubeconfigId: 'K8S',
                    enableConfigSubstitution: true
                    ) 
            kubernetesDeploy(
                    configs: 'service.yaml',
                    kubeconfigId: 'K8S',
                    enableConfigSubstitution: true
                    ) */
        }
        
        stage('Post-build Section') {
            
            mail bcc: '',
            cc: '', 
            from: '', replyTo: '', 
            subject: "Successfully Deployed into Dev Environment", to: "${mail_to}",
            body: "Job :'${env.JOB_NAME}' \n Build No. :'${env.BUILD_NUMBER}' \n Build Url :'${env.BUILD_URL}'"
            
                
        }
        
    }catch(Exception exp){
        
        mail bcc: '',
            cc: '', 
            from: '', replyTo: '', 
            subject: "Error in Deployment for Dev Environment", to: "${mail_to}",
            body: "Job :'${env.JOB_NAME}' \n Build No. :'${env.BUILD_NUMBER}' \n Build Url :'${env.BUILD_URL}'"
            


    }


}
