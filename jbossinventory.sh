#!/bin/bash

#SERVER_GROUP=$(/opt/jboss/bin/jboss-cli.sh -c --command="ls /server-group")
HOSTS=$(/opt/jboss/bin/jboss-cli.sh -c --command="ls /host")



for i in ${HOSTS[@]}
    do

        SERVER=$(/opt/jboss/bin/jboss-cli.sh -c --command="ls /host=$i/server")

        for j in ${SERVER[@]}
            do

            SERVERGROUP=$(/opt/jboss/bin/jboss-cli.sh -c --command="/host=$i/server-config=$j:read-attribute(name=group)" |grep result |awk '{ print $3 }' | sed -e 's/\"//g')
            HEAPSIZE=$(/opt/jboss/bin/jboss-cli.sh -c --command="/server-group=$SERVERGROUP/jvm=default:read-attribute(name=heap-size)" |grep result |awk '{ print $3 }' | sed -e 's/\"//g')
            DEPLOY=$(/opt/jboss/bin/jboss-cli.sh -c --command="ls /host=$i/server=$j/deployment")
            for k in ${DEPLOY[@]}
                do
                echo "$i;$j;$SERVERGROUP;$HEAPSIZE;$k"
                done
        
    done