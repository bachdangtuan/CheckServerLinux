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

# ---------Trả về kết quả----------

echo $cpuUsed
echo $totalRam
echo $usedRam
echo $ipserver
echo $nameserver
echo $disklocal
echo $diskused


