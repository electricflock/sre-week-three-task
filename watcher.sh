#!/bin/bash

#define options
namespace="sre"
app="swype-app"
max_restart=4


while true; do
  
  #count number of restarts
  rstcount=$(kubectl get pods -n $namespace -l app=$app -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  echo -n "has restarted $rstcount"
  echo " times"

  #if count is more than the max restart amount
  if (( rstcount >= max_restart )); then
    echo "too many restarts. time to shut it down"
    kubectl scale --replicas=0 deployment/$app -n $namespace
    sleep 5
    #this below part could be used if setting up interactively in a screen session
    #with nohup it is not ideal
    #read -p "Press Enter to Restart app"
    #kubectl scale --replicas=1 deployment/$app -n $namespace
    #instead use break
    echo "will now exit"
    break
  else
  echo "under the threshold. will wait"
  date
  sleep 60
  
  
  fi

done
