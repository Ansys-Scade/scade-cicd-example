pipeline {
  agent any
  environment { 
    // select the SCADE version to execute actions
    SCADE_DIR = "C:\\Program Files\\ANSYS Inc\\v231\\SCADE"
    // SCADE project relative path without extension
    SCADE_PROJECT_ROOT = "CruiseControl\\CruiseControl"
    // SCADE test project relative path without extension
    SCADE_PROJECT_TEST_ROOT = "CruiseControl_Test\\CruiseControl_Test"
    // SCADE test result project relative path without extension
    SCADE_PROJECT_TEST_RESULT_ROOT = "CruiseControl_Test\\CruiseControl_Test"
    // SCADE Configurations
    CONF_CHECK = "KCG"
    CONF_REPORT = "RTF"
    CONF_GEN = "KCG"
    CONF_TEST = "Test"
  }

  stages {
    stage('Check') {
      steps {
        powershell './scade-cicd/scripts/CheckModel.bat "${env:SCADE_PROJECT_ROOT}.etp" "${env:CONF_CHECK}"'
      }
      post {
        always {
              archiveArtifacts artifacts = 'CruiseControl\\CruiseControl_rules.htm'
          }
      }
    }

    stage('Report Design') {
      steps {
        powershell './scade-cicd/scripts/ReportModel.bat "${env:SCADE_PROJECT_ROOT}.etp" "${env:CONF_REPORT}"'
      }
    }

    stage('Generate Code') {
      steps {
        powershell './scade-cicd/scripts/GenerateCode.bat "${env:SCADE_PROJECT_ROOT}.etp" "${env:CONF_GEN}"'
      }
    }

    stage('Tests') {
      steps {
        powershell './scade-cicd/scripts/ExecuteTests.bat "${env:SCADE_PROJECT_TEST_ROOT}.etp" "${env:SCADE_PROJECT_TEST_RESULT_ROOT}.etp" "${env:CONF_TEST}"'
      }
      post {
        always {
              junit 'CruiseControl_Test\\CruiseControl_Test_tee.xml'
          }
      }
    }

    stage('Coverage') {
      steps {
        powershell './scade-cicd/scripts/AcquireCoverage.bat "${env:SCADE_PROJECT_TEST_ROOT}.etp" "${env:SCADE_PROJECT_TEST_RESULT_ROOT}.etp" "${env:CONF_TEST}"'
      }
      post {
        always {
              archiveArtifacts artifacts = 'CruiseControl_Test\\CruiseControl_Test_mcsummary.html'
          }
      }
    }
  }
}
