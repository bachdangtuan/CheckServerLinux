#!bin/bash
# ip server cần check
# Variable Enviroiment
URL_API='http://localhost:5000'
ip=10.0.0.54
passServer='Isofh#r0Ot@2023*'
username='root'
pathscript='isofh'
idMayAo=1
# Isofh
isofh8=1
isofh89=2
isofh92=3
isofh119=4
isofh248=5
isofh250=6
isofh252=7
isofh254=8
# Viện E
bve70=9
bve254=10
# Medi
medi91=11
medi92=12
medi93=13
medi94=14
# SanhPhon
xanhphon10=15
xanhphon11=16
xanhphon12=17
# DKTH
dkth53=18
dkth54=19
dkth56=20
dkth11=21
dkth12=22
dkth13=23
# Phoi
phoi249=24
phoi250=25
phoi252=26
phoi254=27
# DHY
dhy165=28
dhy167=29
dhy181=30
# TTTM
tttm233=31
tttm234=32
# TA
ta104=33
# YTCC
ytcc2121=34
ytcc2123=34
# YKHN
ykhn104=36


ketqua=$(sshpass -p $passServer ssh $username@$ip "cd /home/${pathscript}/monitorserver && bash monitorScriptCheck.sh")
# Đọc kết quả
readarray -t result_array <<< "$ketqua"

# Server Status
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

postAPIServerStatus(){
curl -X POST ${URL_API}/api/virtualmachine/create \
-H "Content-Type: application/json" \
-d '{"ipaddress": "'"$ipserver"'",
     "nameVirtualMachine": "'"$nameserver"'",
     "cpu": "'"$cpuUsed"'",
     "ram": "'"$totalRam"'",
     "usedram": "'"$usedRam"'",
     "disk": "'"$disklocal"'",
     "diskused": "'"$diskused"'",                    
     "belongtoPhysicalMachine": "'"$isofh119"'"
     }'
}


echo ----- Service container -----

     arrContainer=($(echo "$listcontainers" | cut -d " " -f 1-))
     arrCPU=($(echo "$listCPUcontainer" | cut -d " " -f 1-))
     arrRam=($(echo "$listRamcontainer" | cut -d " " -f 1-))
postAPIContainerStatus(){

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
                         "belongtoVirtualMachine": "'"$idMayAo"'"
                    }' \
          http://localhost:5000/api/servicecontainer/create \
          -O /dev/null
     done

}


if [ ${#arrContainer[@]} -gt 0 ]
then
    echo "Có container"
    postAPIServerStatus
    postAPIContainerStatus
else
    echo "Không có"
    postAPIServerStatus
fi
