#!/usr/bin/env bash

if [ "$#" -eq 3 ]
then
    oc project > /dev/null 2>&1
    
    SERVER_RESPONSE=$(echo $?)
    if [[ SERVER_RESPONSE -eq 1 ]]
    then
        echo "Please check if you're currently login to the OpenShift Development Cluster --- https://rhosd-console.services.adelaide.edu.au:8443/ "
        echo "If not, please do execute the command 'oc login https://rhosd-console.services.adelaide.edu.au:8443/' and enter your credentials."
        exit 1
    fi

    sed -i -e '/UoA_INTEGRATION_APP_UNIQUE_NAME/d' pipeline-params > /dev/null 2>&1
    sed -i -e '/VERSION/d' pipeline-params > /dev/null 2>&1
    sed -i -e '/APP_NAME/d' pipeline-params > /dev/null 2>&1

    UoA_INTEGRATION_APP_UNIQUE_NAME=$(cat pipeline-params | grep -i 'APPLICATION_GIT_URI' | cut -d= -f2 | awk -F'/' '{print $2}' | awk -F'.git' '{print $1}' | sed 's/\./-/g')
    JENKINS_NAMESPACE=$(cat pipeline-params | grep -i 'JENKINS_NAMESPACE' | cut -d= -f2)
    echo  -e "\nUoA_INTEGRATION_APP_UNIQUE_NAME=$UoA_INTEGRATION_APP_UNIQUE_NAME" >> pipeline-params

    pwd > /dev/null 2>&1
    cd ../.. > /dev/null 2>&1
    pwd > /dev/null 2>&1
    APP_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
    VERSION=$(echo 'v'$APP_VERSION | sed 's/\./-/g')

    echo -e "\nVERSION=$VERSION" >> ./conf/pipeline/pipeline-params
    cd ./conf/pipeline > /dev/null 2>&1

    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sed -i -e '/^$/d' pipeline-params
    else
        sed -i '/^$/d' pipeline-params
    fi
    
    echo ***************PIPELINE PARAMS***************
    cat pipeline-params
    echo ***************END OF PIPELINE PARAMS***************
    echo "Using $1 template and $2 params for executing the oc process in the $3 namespace."
    ENVT=$(cat pipeline-params | grep -i 'ENVT' | cut -d= -f2 )
    oc process -f "$1" --param-file="$2"  | oc apply -n "$3" -f -
    sleep 5
    RHOSD='https://rhosd-console.services.adelaide.edu.au:8443'

    HOOK_PART_URL=$(oc get bc $UoA_INTEGRATION_APP_UNIQUE_NAME-$VERSION-$ENVT-pipeline -n $JENKINS_NAMESPACE -o go-template='{{.metadata.selfLink}}')
    SECRET=$(oc get bc $UoA_INTEGRATION_APP_UNIQUE_NAME-$VERSION-$ENVT-pipeline -n $JENKINS_NAMESPACE -o go-template='{{range .spec.triggers}}{{.gitlab.secret}}{{end}}')
    WEBHOOK="$RHOSD$HOOK_PART_URL/webhooks/$SECRET/gitlab"

    echo
    echo  "********** Dont forget to configure your dev pipeline webhook in GitLab using the following url below. **********"
    echo
    echo  "WEBHOOK URL: $WEBHOOK"
    echo
    exit 0
else
    echo This script needs 3 arguments to work.
    exit 1
fi

# Script Usage
# Assumption is you are signed-in to the OpenShift Devt cluster before executing this script.
# oc login https://rhosd-console.services.adelaide.edu.au:8443
# ./oc-apply-pipeline-template.sh <template.yaml> pipeline-params integration-jenkins-dev
# ./oc-apply-pipeline-template.sh student-records-pipeline-template.yaml pipeline-params integration-jenkins-dev
