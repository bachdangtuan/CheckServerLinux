#!bin/bash
# Cài đặt vào server Ubuntu để ssh check
# Check Ram Server

totalRam=$(free -ht | awk 'NR==2{print $2}')
usedRam=$(free -ht | awk 'NR==2{print $3}')
networkCard=eno16780032

# Check CPU
usedCPU=$(top -n 1 -b | grep '%Cpu(s)' | awk '{print $2+$4}')
# Check dia chi IP
myip=$(ip addr show $networkCard | grep "inet\b" | awk '{print $2}' | cut -d/ -f1 | head -n 1)

# Check tên máy chủ
nameserver=$(hostname)

# Check ổ cứng, thư mục root
# $4: phần trăm sử dụng , $1 tên filesystems , $2 tổng kích cỡm $3 dụng lượng sử dụng, $5 thư mục
disklocal=$(df -h / | awk 'NR==2 {print $2}')
diskused=$(df -h / | awk 'NR==2 {print $3}')



# TH1 Có dịch docker 

checkerFull(){
        containers=$(docker ps -a --format '{{.Names}}')
        IFS=$'\n' read -d '' -ra container_array <<< "$containers"

        container_obj=()
        container_cpu=()
        container_ram=()

        for container in "${container_array[@]}"
        do
        # Add phần tử vào mảng dữ liệu
        container_cpu+=$(docker stats --no-stream ${container} --format "{{.CPUPerc}}"  | sed 's/%/ /g')
        container_obj+=("$container")
        container_ram+=$(docker stats --no-stream ${container} --format "{{.MemPerc}}"  | sed 's/%/ /g')
        done


        #-------- Xuất dữ liệu----------------------
        echo "$usedCPU"
        echo "$totalRam"
        echo "$usedRam"
        echo "$myip"
        echo "$nameserver"
        echo "$disklocal"
        echo "$diskused"
        #-------- Xuất dữ liệu về container----------------------
        echo "${container_obj[@]}"
        echo "${container_cpu[@]}"
        echo "${container_ram[@]}"
}

checkerServer(){
    echo "$usedCPU"
    echo "$totalRam"
    echo "$usedRam"
    echo "$myip"
    echo "$nameserver"
    echo "$disklocal"
    echo "$diskused"
}



######## Check danh sách container hoạt động
if systemctl is-active --quiet docker.service ; then
  checkerFull
else
  checkerServer
fi







