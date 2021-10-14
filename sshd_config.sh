#!/bin/bash

ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_NOTROOT=87   # Non-root exit error.

# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi


ssh_directory="/etc/ssh/sshd_config"
AllowTcpForwarding="$(cat $ssh_directory | grep '^#'AllowTcpForwarding[[:space:]]yes)" # #AllowTcpForwarding yes seklinde olanlari gösterir.
#ClientAliveCountMax=$"(cat $ssh_directory | grep '^#'ClientAliveCountMax)"

 if [ "$AllowTcpForwarding" == "#AllowTcpForwarding yes" ];
then
	sed -i s/#AllowTcpForwarding\ yes/AllowTcpForwarding\ no/g $ssh_directory
	echo "$AllowTcpForwarding has been changed AllowTcpForwarding no"
else
	echo "AllowTcpForwarding no already updated"
 fi

Compression="$(cat $ssh_directory | grep '^#'Compression[[:space:]]delayed)" #


if [ "$Compression" == "#Compression delayed" ];
then
sed -i s/#Compression\ delayed/Compression\ no/g $ssh_directory
echo "$Compression has been changed Compression no"
else
echo "Compression no already updated"
fi













#if [ "$ClientAliveCountMax" == "#ClientAliveCountMax" ];
#then
#sed -i s/#ClientAliveCountMax\ 3/ClientAliveCountMax\ 2/g $ssh_directory
#echo "$ClientAliveCountMax has been changed ClientAliveCountMax 2"
#else
#echo "ClientAliveCountMax 2 already updated"
#fi

