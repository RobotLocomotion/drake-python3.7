#!/usr/bin/env groovy

pipeline {
    agent {
        docker {
            image '333343588315.dkr.ecr.us-east-1.amazonaws.com/drake:ubuntu-18.04'
        }
    }
    environment {
        SSH_PRIVATE_KEY = credentials('ad794d10-9bc8-4a7a-a2f3-998af802cab0')
    }
    options {
        buildDiscarder(logRotator(daysToKeepStr: '14'))
        disableResume()
        skipStagesAfterUnstable()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }
    stages {
        stage('setup') {
            steps {
                sh 'sudo -EH ./ci/scripts/setup'
            }
        }
        stage('test') {
            steps {
                sh './ci/scripts/test'
            }
        }
        stage('package') {
            steps {
                sh './ci/scripts/package'
            }
            post {
                success {
                    s3Upload(
                        file: "${env.BUILD_TAG}.tar.gz",
                        bucket: 'drake-packages',
                        path: "drake/rt/${env.BUILD_TAG}.tar.gz"
                    )
                    createSummary(
                        icon: 'folder.gif',
                        text: "<a href=\"https://drake-packages.csail.mit.edu/drake/rt/${env.BUILD_TAG}.tar.gz\">https://drake-packages.csail.mit.edu/drake/rt/${env.BUILD_TAG}.tar.gz</a>"
                    )
                }
            }
        }
    }
}
