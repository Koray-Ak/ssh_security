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

read -p "Server SSH $default_ssh_port. Do you want to changed SSH Port? [y/n]: " answer_port

if [[ "$answer_port" = y  ||  "$answer_port" = Y ]]; then

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
        systemctl restart ssh
        systemctl status ssh

echo "Lynis is a battle-tested security tool for systems running Linux, macOS, or Unix-based operating system. It performs an extensive health scan of your systems to support system hardening and compliance testing. "
read -p "Do you want to install Lynis? [y/n] : " answer_lynis
if [[ $answer_lynis = y || $answer_lynis = Y ]]; then
lynis_check="/etc/lynis/"
  if [ -d $lynis_check ]; then
    echo "Lynis is already installed"
    lynis audit system;
    cat /var/log/lynis.log | ack SSH
  else
    apt install lynis -y
    apt install ack -y
    lynis audit system;
    cat /var/log/lynis.log | ack SSH
  fi
else
  exit 1;
fi

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
