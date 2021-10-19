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

read -p "Change the default SSH port22: " SSH_PORT
        sed -i \
        -e "s|#Port 22|Port ${SSH_PORT}|g" \
        -e "s|#ClientAliveCountMax 3|ClientAliveCountMax 2|g" \
        -e "s|#PermitRootLogin prohibit-password|PermitRootLogin no|g" \
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
        echo "#Port 22 has been changed $SSH_PORT"
        echo "#ClientAliveCountMax 3 has been changed ClientAliveCountMax 2"
        echo "#PermitRootLogin prohibit-password has been changed PermitRootLogin no"
	echo "#AllowTcpForwarding yes has been changed AllowTcpForwarding no"
	echo "#Compression delayed has been changed Compression no"
	echo "#LogLevel INFO has been changed LogLevel VERBOSE"
	echo "#MaxAuthTries 6 has been changed MaxAuthTries 2"
	echo "#MaxSessions 10 has been changed MaxSessions 2"
	echo "#TCPKeepAlive yes has been changed TCPKeepAlive no"
	echo "X11Forwarding yes has been changed X11Forwarding no"
	echo "#AllowAgentForwarding yes has been changed AllowAgentForwarding no"
	echo "#LoginGraceTime 2m has been changed LoginGraceTime 1m"
        systemctl reload ssh

#This option is not mandatory,if you want to prevent from restrict number of sessions via SSH connections, you can use.
#etc_security_path="/etc/security/limits.conf"
#maxlogins="gisadmin - maxlogins  2"
#if grep -q "$maxlogins" "$etc_security_path" ; then
#	exit
#else
#	echo "$maxlogins" >> $etc_security_path
#fi
