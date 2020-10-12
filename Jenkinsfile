@Library('jenkins_lib')_
pipeline
 {
    agent {label 'slave'}

    environment {

        project = "apache-spark";
        buildNum = currentBuild.getNumber() ;
        //ex. like feat, release, fix
        buildType = BRANCH_NAME.split("/").first();
        //ex. like OP-<User-Story ID>
        branchVersion = BRANCH_NAME.split("/").last().toUpperCase();
        // Define global environment variables in this section
    }

    stages {
        stage("Define Release version") {
            steps {
                script {
                    //Global Lib for Environment Versions Definition
                    versionDefine()
                }
            }
        }

        stage("Versioning") {
            steps {
                sh 'mvn versions:set -DnewVersion=${VERSION}'
            }
        }

        stage("Initialize Variable") {
            steps {
                script {
                    PUSH_JAR = false;
                    longCommit = sh(returnStdout: true, script: "git rev-parse HEAD").trim()

                    if( env.buildType in ['release'] )
                    {
                        PUSH_JAR = true;
                    }
                }

            }
        }

        stage("Push JAR to Maven Artifactory") {
            when {
                expression { PUSH_JAR == true }
            }
            steps {
                script {
                    echo "Pushing JAR to Maven Artifactory"
                    sh "mvn deploy -U -Dcheckstyle.skip=true -Denforcer.skip=true -Dmaven.test.skip=true;"
                }
            }
        }
    }

 }

