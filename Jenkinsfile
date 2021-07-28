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
                    env.GUAVUS_SPARK_VERSION = "${VERSION}".split(",").first();
                    env.GUAVUS_DOCKER_VERSION = "${VERSION}".split(",").last();
                    env.dockerTag = "${GUAVUS_SPARK_VERSION}-hadoop3.2-${GUAVUS_DOCKER_VERSION}-${RELEASE}" 
                    echo "GUAVUS_SPARK_VERSION : ${GUAVUS_SPARK_VERSION}"
                    echo "GUAVUS_DOCKER_VERSION : ${GUAVUS_DOCKER_VERSION}"
                    echo "DOCKER TAG : ${dockerTag}"
                }
            }
        }

        stage("Versioning") {
            steps {
                echo "GUAVUS_SPARK_VERSION : ${GUAVUS_SPARK_VERSION}"
                echo "GUAVUS_DOCKER_VERSION : ${GUAVUS_DOCKER_VERSION}"
                sh 'mvn versions:set -DnewVersion=${GUAVUS_SPARK_VERSION}'
                sh 'mvn install:install-file -Dfile=log4j-api-2.14.1.jar -DgroupId=log4j -DartifactId=log4j -Dversion=2.14.1 -Dpackaging=jar'
                sh 'mvn install:install-file -Dfile=log4j-1.2-api-2.14.1.jar -DgroupId=log4j -DartifactId=log4j -Dversion=2.14.1 -Dpackaging=jar'
                sh 'mvn install:install-file -Dfile=log4j-core-2.14.1.jar -DgroupId=log4j -DartifactId=log4j -Dversion=2.14.1 -Dpackaging=jar'
            }
        }

        stage("Initialize Variable") {
            steps {
                script {
                    PUSH_JAR = false;
                    PUSH_DOCKER = false;
                    DOCKER_IMAGE_NAME = "spark-opsiq";
                    PYSPARK_DOCKER_IMAGE_NAME = "spark-py-opsiq";
                    longCommit = sh(returnStdout: true, script: "git rev-parse HEAD").trim()

                    if( env.buildType in ['release'] )
                    {
                        PUSH_JAR = true;
                        PUSH_DOCKER = true;
                    }
                    else if ( env.buildType ==~ /PR-.*/ ) {
                        PUSH_DOCKER = true;
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
                    sh "mvn deploy -U -Dcheckstyle.skip=true -Denforcer.skip=true -DskipTests=true;"
                }
            }
        }

        stage("Build and Push Docker") {
                    when {
                        expression { PUSH_DOCKER == true }
                        }
                    stages {
                        stage("Create Docker Image") {
                            steps {
                                script {
                                    echo "Creating docker build..."
                                    sh "./dev/make-distribution.sh --name guavus_spark-${GUAVUS_SPARK_VERSION}-3.2.0 -Phive -Phive-thriftserver -Pkubernetes -Phadoop-3.2 -Dhadoop.version=3.2.0"
                                    sh "./dist/bin/docker-image-tool.sh -r artifacts.ggn.in.guavus.com:4244 -t ${GUAVUS_SPARK_VERSION}-hadoop3.2-${GUAVUS_DOCKER_VERSION} build"
                                    sh "./dist/bin/docker-image-tool.sh -r artifacts.ggn.in.guavus.com:4244 -t ${GUAVUS_SPARK_VERSION}-hadoop3.2-${GUAVUS_DOCKER_VERSION} push"
                                    sh "./dist/bin/docker-image-tool.sh -r artifacts.ggn.in.guavus.com:4244 -t ${GUAVUS_SPARK_VERSION}-hadoop3.2-${GUAVUS_DOCKER_VERSION} -p ./resource-managers/kubernetes/docker/src/main/dockerfiles/spark/bindings/python/Dockerfile build"
                                    sh "./dist/bin/docker-image-tool.sh -r artifacts.ggn.in.guavus.com:4244 -t ${GUAVUS_SPARK_VERSION}-hadoop3.2-${GUAVUS_DOCKER_VERSION} -p ./resource-managers/kubernetes/docker/src/main/dockerfiles/spark/bindings/python/Dockerfile push"
                                    sh "docker build -t ${DOCKER_IMAGE_NAME} --build-arg GIT_HEAD=${longCommit} --build-arg GIT_BRANCH=${env.BRANCH_NAME} --build-arg VERSION=${dockerTag} --build-arg BUILD_NUMBER=${env.BUILD_NUMBER} ."
                                    sh "docker build -f PysparkDockerfile -t ${PYSPARK_DOCKER_IMAGE_NAME} --build-arg GIT_HEAD=${longCommit} --build-arg GIT_BRANCH=${env.BRANCH_NAME} --build-arg VERSION=${dockerTag} --build-arg BUILD_NUMBER=${env.BUILD_NUMBER} ."
                                }
                            }
                        }

                        stage("PUSH Docker") {
                            steps {
                                script {
                                    echo "Docker PUSH..."
                                    docker_push( buildType, DOCKER_IMAGE_NAME )
                                    docker_push( buildType, PYSPARK_DOCKER_IMAGE_NAME )
                                }
                            }
                        }
                    }
                }

    }

 }

