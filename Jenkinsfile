def uniTestThreshold = 50;

       
    try {

        node {
            //notify('Started')
            def propsLoader = load("../${JOB_NAME}@script/libs/groovy/PropertyReader.groovy")
            def props = propsLoader("${WORKSPACE}@script/config", 'brixserver','dev')
 	     print props.getProperty('enable.email.notification'); 
          
            stage '\u2776 Checkout'
                git 'ssh://git@bitbucket.pearson.com/brix/brix-server-nextgen.git'
            
            stage 'Unit tests'
                sh 'npm install'
                sh 'make test-coverage'
                def calcUnitTestCoverage = load("../${JOB_NAME}@script/libs/groovy/HtmlParser.groovy")
                if (calcUnitTestCoverage("${WORKSPACE}/reports/lcov-report/index.html") < uniTestThreshold) {
                   throw new Exception('Dropped Unit Test Coverage');
                }
            stage 'SonarQube analysis'
                def scannerHome = tool 'SonarQube Scanner 2.8';
                withSonarQubeEnv('Sonar Pearson') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
     
            stage 'Publish HTML reports'
                publishHTML(target: [allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'reports/lcov-report/', reportFiles: 'index.html', reportName: 'Coverage Report'])
                
            stage 'Checkmarx Scan'
                build job: 'Checkmarx_Server'
        }

        stage 'Deploy'
            input 'Do you want to deploy?'
           
        stage 'S3Upload'
              sh("cd ../${JOB_NAME}@script/libs/shell && sed -ie 's/#KEY_ID/AKIAJKJDWVRHQFFO3SIA/g' s3upload.sh && sed -ie 's/#SCRT_ID/YeuG9xO7nTxGtPA98IuQSMUyijHHZJZ4gspA0IEH/g' s3upload.sh")
              sh('cd ../${JOB_NAME}@script/libs/shell && sh s3upload.sh Rel_4.0.0-dev /home/sureshgeenath/AWS/brix-testing-platform.zip zip')
           
    } catch(error) {
        notify("Error ${error}")
        echo "Caught: ${error}"
        currentBuild.result = 'FAILURE'
    }



def notify(status){
    emailext (
      to: "visionx.manoj@gmail.com",
      subject: "${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
    )
}
