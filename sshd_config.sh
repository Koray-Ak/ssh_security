#!/bin/bash

ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_NOTROOT=87   # Non-root exit error.

# Run as Root or Sudo User, of course.
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be Root or SUDO User to run this script."
  exit $E_NOTROOT
fi

ssh_directory="/etc/ssh/sshd_config"

default_ssh_port="$(cat $ssh_directory | grep -m 1 Port)"

read -p "Server SSH $default_ssh_port. Do you want to changed SSH Port? [y/n]: " answer

if [[ "$answer" = y  ||  "$answer" = Y ]]; then

read -p "Change the default SSH $default_ssh_port: " SSH_PORT

        sed -i \
        -e "s|#Port 22|Port ${SSH_PORT}|g" \
        -e "s|${default_ssh_port}|Port ${SSH_PORT}|g" \
        -e "s|#ClientAliveCountMax 3|ClientAliveCountMax 2|g" \
        -e "s|#PermitRootLogin prohibit-password|PermitRootLogin no|g" \
        -e "s|PermitRootLogin yes|PermitRootLogin no|g" \
	-e "s|#AllowTcpForwarding yes|AllowTcpForwarding no|g" \
	-e "s|#Compression delayed|Compression no|g" \
	-e "s|#LogLevel INFO|LogLevel VERBOSE|g" \
	-e "s|#MaxAuthTries 6|MaxAuthTries 2|g" \
	-e "s|#MaxSessions 10|MaxSessions 2|g" \
	-e "s|#TCPKeepAlive yes|TCPKeepAlive no|g"\
	-e "s|X11Forwarding yes|X11Forwarding no|g" \
	-e "s|#AllowAgentForwarding yes|AllowAgentForwarding no|g" \
	-e "s|#LoginGraceTime 2m|LoginGraceTime 1m|g" \
        $ssh_directory
        systemctl reload ssh
else
 exit 1;
fi


#This option is not mandatory,if you want to prevent from restrict number of sessions via SSH connections, you can use.
#etc_security_path="/etc/security/limits.conf"
#maxlogins="gisadmin - maxlogins  2"
#if grep -q "$maxlogins" "$etc_security_path" ; then
#	exit
#else
#	echo "$maxlogins" >> $etc_security_path
#fi
