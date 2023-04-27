#! bin/bash
# Cài đặt vào server Ubuntu để ssh check
# Check Ram Server
totalRam=$(free -ht | awk 'NR==2{print $2}')
usedRam=$(free -ht | awk 'NR==2{print $3}')

# Check CPU
usedCPU=$(top -n 1 -b | grep '%Cpu(s)' | awk '{print $2+$4}')
# Check dia chi IP
myip=$(ip addr show ens192 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1 | head -n 1)

# Check tên máy chủ
nameserver=$(hostname)

# Check ổ cứng, thư mục root
# $4: phần trăm sử dụng , $1 tên filesystems , $2 tổng kích cỡm $3 dụng lượng sử dụng, $5 thư mục
disklocal=$(df -h / | awk 'NR==2 {print $2}')
diskused=$(df -h / | awk 'NR==2 {print $3}')



# Xuất dữ liệu
echo "$usedCPU"
echo "$totalRam"
echo "$usedRam"
echo "$myip"
echo "$nameserver"
echo "$disklocal"
echo "$diskused"