#!bin/bash
# ip server cần check
# Variable Enviroiment
ip=10.0.0.20
passServer='123123'
username='ubuntu'

arrayPhysicalMachineIsofh=([isofh-8]=1 [isofh-89]=2 [isofh-92]=3 [isofh-119]=4 [isofh-248]=5 [isofh-250]=6 [isofh-252]=7 [isofh-254]=8)
arrayPhysicalMachineBVE=([bve-70]=9 [bve-254]=10)
arrayPhysicalMachineMedi=([medi-91]=11 [medi-92]=12 [medi-93]=13 [medi-94]=14)
arrayPhysicalMachineXanhPhon=([xanhphon-10]=15 [xanhphon-11]=16 [xanhphon-12]=17)
arrayPhysicalMachineDKTH=([dkth-53]=18 [dkth-54]=19 [dkth-56]=20 [dkth-11]=21 [dkth-12]=22 [dkth-13]=23)
arrayPhysicalMachinePhoi=([phoi-249]=24 [phoi-250]=25 [phoi-252]=26 [phoi-254]=27)
arrayPhysicalMachineDHY=([dhy-165]=28 [dhy-167]=29 [dhy-181]=30)
arrayPhysicalMachineTTTM=([tttm-233]=31 [tttm-234]=32)
arrayPhysicalMachineTA=([ta-104]=33 )
arrayPhysicalMachineYTCC=([ytcc-2121]=34 [ytcc-2123]=35)
arrayPhysicalMachineYKHN=([ykhn-104]=36 )

ketqua=$(sshpass -p $passServer ssh $username@$ip 'cd /home/ubuntu/CheckServerLinux && bash check-server.sh')
# Đọc kết quả
readarray -t result_array <<< "$ketqua"

cpuUsed=${result_array[0]}
totalRam=${result_array[1]}
usedRam=${result_array[2]}
ipserver=${result_array[3]}
nameserver=${result_array[4]}
disklocal=${result_array[5]}
diskused=${result_array[6]}





# Container Status
listcontainers=${result_array[7]}
listCPUcontainer=${result_array[8]}
listRamcontainer=${result_array[9]}

# ---------Trả về kết quả----------
echo ----- Máy ảo -----
echo 'cpu sử dụng' $cpuUsed
echo 'tổng ram' $totalRam
echo 'ram sử dụng' $usedRam
echo 'ip của serer' $ipserver
echo 'name server' $nameserver
echo 'dung lượng đĩa' $disklocal
echo 'dung lượng đĩa sử dụng' $diskused

wget --header="Content-Type: application/json" \
     --post-data='{"ipaddress": "'"$ipserver%"'",
                    "nameVirtualMachine": "'"$nameserver"'",
                    "cpu": "'"$cpuUsed"'",
                    "ram": "'"$totalRam"'",
                    "usedram": "'"$usedRam"'",
                    "disk": "'"$disklocal"'",
                    "diskused": "'"$diskused"'",                    
                    "belongtoPhysicalMachine": "'"${arrayPhysicalMachineIsofh[isofh-92]}"'"
                   }' \
     http://localhost:5000/api/virtualmachine/create \
     -O /dev/null



echo ----- Service container -----

arrContainer=($(echo "$listcontainers" | cut -d " " -f 1-))
arrCPU=($(echo "$listCPUcontainer" | cut -d " " -f 1-))
arrRam=($(echo "$listRamcontainer" | cut -d " " -f 1-))

for (( i=0; i<${#arrContainer[@]}; i++ ));
do  
    # Call API đến service container
    container="${arrContainer[$i]}"
    cpu="${arrCPU[$i]}"
    ram="${arrRam[$i]}"
    echo "Container $container sử dụng cpu là: $cpu  sử dụng ram là: $ram " 

wget --header="Content-Type: application/json" \
     --post-data='{"ipaddress": "'"$ipserver"'",
                    "nameServiceContainer": "'"$container"'",
                    "cpu": "'"$cpu"'",
                    "ram": "'"$ram"'",
                    "disk": "20%",
                    "belongtoVirtualMachine": 1
                   }' \
     http://localhost:5000/api/servicecontainer/create \
     -O /dev/null


done