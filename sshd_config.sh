#!/bin/bash
ssh_directory="/etc/ssh/sshd_config"


AllowTcpForwarding="$(cat $ssh_directory | grep '^#'AllowTcpForwarding[[:space:]]yes)" # #AllowTcpForwarding yes seklinde olanlari gösterir.

if [ "$AllowTcpForwarding" == "#AllowTcpForwarding yes" ];
then
echo "$AllowTcpForwarding"
sed -i s/#AllowTcpForwarding\ yes/AllowTcpForwarding\ no/g $ssh_directory
echo "has been changed AllowTcpForwarding no"
else
echo "AllowTcpForwarding no already updated"
fi
