#!/bin/bash
clear
cf t -o DigitalConnect -s enterprise-connect > /dev/null
tmp=$(cf a | awk {'print $1'} | egrep "([a-z|0-9]{8,8}\-[a-z|0-9]{4,4}\-[a-z|0-9]{4,4}\-[a-z|0-9]{4,4}\-[a-z|0-9]{11,12})")
IFS=$'\n' read -d '' -r -a appnames <<< "$tmp"
echo "["
j=1
    for ((i=0; i<${#appnames[@]} ; i++))
        do
appguid[$i]=$(cf app ${appnames[$i]} --guid)
appname[$i]=${appnames[$i]}
serviceinstancename[$i]=$(cf curl /v2/service_instances/${appname[$i]} | grep name)
    if [ -n "${serviceinstancename[$i]}" ]; then
appstats[$i]=$(cf curl /v2/apps/${appguid[$i]}/stats | egrep "state|cpu|disk|memory|mem_quota| disk_quota |mem")
printf '\n'
echo "{"
echo "${serviceinstancename[$i]}"
echo "\"App Name\":\"${appname[i]}\","
echo "${appstats[$i]}"","
echo "\"eventType\": \"ECServiceInstance\""
printf '\n'
#echo "$j"
# echo "${serviceinstancename[$j]}"
        if [ -n "${appguid[$j]}" ]; then
            echo "},"
        else
            echo "}"
        fi
  #  else
  #      echo "Service deleted"    
   let j=j+1 
     fi 
        done
echo "]"