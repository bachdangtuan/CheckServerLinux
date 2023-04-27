#! bin/bash

# Check Ram Server
totalRam=$(free -ht | awk 'NR==2{print $2}')
usedRam=$(free -ht | awk 'NR==2{print $3}')

# Check CPU
usedCPU=$(top -n 1 -b | grep '%Cpu(s)' | awk '{print $2+$4}')






# Xuất dữ liệu
echo "$usedCPU"
echo "$totalRam"
echo "$usedRam"