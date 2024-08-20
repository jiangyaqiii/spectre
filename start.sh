#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

echo "\$nrconf{kernelhints} = 0;" >> /etc/needrestart/needrestart.conf
echo "\$nrconf{restart} = 'l';" >> /etc/needrestart/needrestart.conf

# 节点安装功能
apt update
apt install screen unzip -y

wget https://github.com/spectre-project/rusty-spectre/releases/download/v0.3.15/rusty-spectre-v0.3.15-linux-gnu-amd64.zip
unzip rusty-spectre-v0.3.15-linux-gnu-amd64.zip
cd ~/bin
./spectred --utxoindex &
SPECTRED_PID=$!
sleep 3
kill $SPECTRED_PID
cd
wget https://spectre-network.org/downloads/legacy/datadir2.zip
unzip datadir2.zip -d .rusty-spectre/spectre-mainnet
cd ~/bin
screen -dmS spe bash -c './spectred --utxoindex'

wget https://github.com/spectre-project/spectre-miner/releases/download/v0.3.17/spectre-miner-v0.3.17-linux-gnu-amd64.zip
unzip spectre-miner-v0.3.17-linux-gnu-amd64.zip

cd ~/bin
read -p "请输入挖矿钱包地址: " wallet_addr
read -p "请输入挖矿CPU核心数: " cpu_core

screen -dmS spewa bash -c "./spectre-miner-v0.3.17-linux-gnu-amd64 --mining-address $wallet_addr --threads $cpu_core --spectred-address 127.0.0.1"
echo "====================== 启动挖矿节点完成 请使用screen -r spewa 查看运行情况 ==========================="
