#!bin/bash
# ip server cần check
# Variable Enviroiment
ip=10.0.0.20
passServer=123123

ketqua=$(sshpass -p $passServer ssh ubuntu@$ip 'cd /home/ubuntu/check && bash check_info.sh')
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

echo ----- Service container -----

arrContainer=($(echo "$listcontainers" | cut -d " " -f 1-))
arrCPU=($(echo "$listCPUcontainer" | cut -d " " -f 1-))
arrRam=($(echo "$listRamcontainer" | cut -d " " -f 1-))

for (( i=0; i<${#arrContainer[@]}; i++ ));
do  
    # Call API ở đây
    container="${arrContainer[$i]}"
    cpu="${arrCPU[$i]}"
    ram="${arrRam[$i]}"
    echo "Container $container sử dụng cpu là: $cpu  sử dụng ram là: $ram " 
done

