#$(cf curl /v2/apps/30a26b83-d3a5-432a-ba81-50465df0cf85/stats | jq '.[] | {status:.state}' | sed 's/\}//g' | sed -E 's/\'{'//g')
#!/bin/bash
clear
cf t -o DigitalConnect -s enterprise-connect > /dev/null
tmp=$(cf a | awk {'print $1'} | egrep "([a-z|0-9]{8,8}\-[a-z|0-9]{4,4}\-[a-z|0-9]{4,4}\-[a-z|0-9]{4,4}\-[a-z|0-9]{11,12})")
IFS=$'\n' read -d '' -r -a appnames <<< "$tmp"
j=1
echo "["
    for ((i=0; i<${#appnames[@]} ; i++))
        do
            appguid[$i]=$(cf app ${appnames[$i]} --guid)
            serviceinstancename[$i]=$(cf curl /v2/service_instances/eaee9f68-2e81-4c69-aa7f-5743502eabb6 | jq '. | {ServiceName:.entity.name}' | sed 's/\}//g' | sed -E 's/\'{'//g')
    if [ -n "${serviceinstancename[$i]}" ]; 
    then
            appstats[$i]=$(cf curl /v2/apps/${appguid[$i]}/stats | jq '.[] | {STATE:.state, DiskQuota:.stats.disk_quota, MemoryQuota:.stats.mem_quota, CPU:.stats.usage.cpu, Memory:.stats.usage.mem, DISK:.stats.usage.disk}' | sed 's/\}//g' | sed -E 's/\'{'//g')
            echo "{"
            #echo "${serviceinstancename[$i]}"
            echo "\"AppName\": \"${appnames[i]}\","
            echo "${appstats[$i]}"","
            echo "\"eventType\": \"ECServiceInstance\""
    if [ -n "${serviceinstancename[$j]}" ]; 
    then         
            echo "}"
    else
            echo "},"
            let j=j+1
    fi                
    else
            echo "Service Deleted"
    fi
            done
echo "]"