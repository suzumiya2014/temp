#!/bin/bash
#
#Swarm Bee node from source

echo "
+----------------------------------------------------------------------
| 创建 Swarm Bee  节点 Ubuntu/Debian
+----------------------------------------------------------------------
| Copyright © 2015-2021 All rights reserved.
+----------------------------------------------------------------------
| 创建者：Suzumiya
+----------------------------------------------------------------------
";sleep 5

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_EN.UTF-8


#初始化环境变量
logPath='/root/bee-run.log'
cashlogPath='/root/cash.log'
passPath='/root/bee-pass.txt'
swapEndpoint='https://goerli.infura.io/v3/83f01244cd044f0f815ff3e34fd0ebff'
cashScriptPath='/root/cashout.sh'
homedir=$HOME
externalIp=$(curl -4 ifconfig.io)



red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }

if [ $(id -u) != "0" ]; then
    echo "错误！必须使用root用户运行本脚本. (请输入: sudo su)"
    exit 1
fi

# 创建bee的服务
createSwarmService(){
    date "+【%Y-%m-%d %H:%M:%S】 Installing the Swarm Bee service" 2>&1 | tee -a $logPath
	if [ ! -f /etc/systemd/system/bee.service ]; then
	cat >> /etc/systemd/system/bee.service << EOF
[Unit]
Description=Bee Bzz Bzzzzz service
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=60
User=root
ExecStart=/usr/local/bin/bee start --config ${homedir}/bee-default.yaml
StandardOutput=append:/var/log/bee.log
StandartError=append:/var/log/bee-err.log
[Install]
WantedBy=multi-user.target
EOF
echo '服务已安装成功'
else date "+【%Y-%m-%d %H:%M:%S】 服务已安装成功" 2>&1 | tee -a $logPath
fi

# 重新加载配置
systemctl daemon-reload

# 使bee服务生效
systemctl enable bee

# 启动bee
systemctl start bee
}


# 安装用于兑现支票的脚本的功能
getCashoutScript(){

if [ ! -f $cashScriptPath ]; then
date "+【%Y-%m-%d %H:%M:%S】 安装支票兑现脚本" 2>&1 | tee -a $logPath
echo '安装支票兑现脚本';sleep 2

# 下载脚本
wget -O $cashScriptPath https://github.com/grodstrike/bee-swarm/raw/main/cashout.sh && chmod a+x $cashScriptPath
else
date "+【%Y-%m-%d %H:%M:%S】 '$cashScriptPath' 文件已存在" 2>&1 | tee -a $logPath
fi

# 设置定时服务
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 */12 * * *  /bin/bash $cashScriptPath cashout-all >> $cashlogPath 2>&1" >> mycron
#install new cron file
crontab mycron
rm -f mycron
systemctl restart crond

}



createConfig(){
date "+【%Y-%m-%d %H:%M:%S】 创建配置文件" 2>&1 | tee -a $logPath
echo '创建配置文件..'; sleep 2
if [ ! -f $homedir/bee-default.yaml ]; then
cat >> $homedir/bee-default.yaml << EOF
api-addr: :1633
bootnode:
- /dnsaddr/bootnode.ethswarm.org
clef-signer-enable: false
clef-signer-endpoint: ""
config: /root/bee-default.yaml
cors-allowed-origins: []
data-dir: /root/.bee
db-capacity: "5000000"
debug-api-addr: :1635
debug-api-enable: true
gateway-mode: false
global-pinning-enable: false
help: false
nat-addr: "${externalIp}:1634"
network-id: "1"
p2p-addr: :1634
p2p-quic-enable: false
p2p-ws-enable: false
password: ""
password-file: ${passPath}
payment-early: "1000000000000"
payment-threshold: "10000000000000"
payment-tolerance: "50000000000000"
resolver-options: []
standalone: false
swap-enable: true
swap-endpoint: ${swapEndpoint}
swap-factory-address: ""
swap-initial-deposit: "100000000000000000"
tracing-enable: false
tracing-endpoint: 127.0.0.1:6831
tracing-service-name: bee
verbosity: 2
welcome-message: "Hello world"
EOF
else date "+【%Y-%m-%d %H:%M:%S】 配置文件已经创建" 2>&1 | tee -a $logPath
fi
}

function Install_Main() {
if [ ! -f $passPath ]; then
date "+【%Y-%m-%d %H:%M:%S】  /root/bee-pass.txt" 2>&1 | tee -a /root/run.log
echo "请输入节点密码 (它将存储在这里 $passPath):"
read  n
echo  $n > $passPath;
date "+【%Y-%m-%d %H:%M:%S】 输入的节点密码是: " && cat $passPath  2>&1 | tee -a /root/run.log
fi

echo 'Установка пакетов...'; sleep 2

date "+【%Y-%m-%d %H:%M:%S】  安装jq套件" 2>&1 | tee -a /root/run.log
sudo apt-get update
sudo apt -y install curl wget tmux jq

echo 'Установка Swarm Bee..'; sleep 2
date "+【%Y-%m-%d %H:%M:%S】 安装 Swarm Bee" 2>&1 | tee -a /root/run.log
curl -s https://raw.githubusercontent.com/ethersphere/bee/master/install.sh | TAG=v0.5.3 bash

echo '即将安装 Bee Clef..'; sleep 2

date "+【%Y-%m-%d %H:%M:%S】 安装 Bee Clef" 2>&1 | tee -a /root/run.log
wget https://github.com/ethersphere/bee-clef/releases/download/v0.4.7/bee-clef_0.4.7_amd64.deb && dpkg -i bee-clef_0.4.7_amd64.deb

wget https://github.com/doristeo/SwarmBeeBzzz/raw/main/local-dash.sh
chmod +x local-dash.sh



createConfig
getCashoutScript
createSwarmService

echo ''
echo "
+----------------------------------------------------------------------"
echo -e "\e[42m安装完成!\e[0m"; echo ''; echo '节点密码:' && cat $passPath && echo '' && echo '存放路径: '; echo $passPath
echo "
+----------------------------------------------------------------------"
echo ''
echo -e 'З节点是否在运行? 检查命令 \e[42msystemctl status bee\e[0m'
echo -e '查看运行日志 \e[42mjournalctl -f -u bee\e[0m'
sleep 10
address="0x`cat ~/.bee/keys/swarm.key | jq '.address'|sed 's/\"//g'`" && echo "您的节点钱包:" && echo ${address}
echo "
+----------------------------------------------------------------------"
echo -e " 接下来，您需要用测试令牌充值您的钱包余额. 复制链接 https://discord.gg/f697tZaZjk , 然后去聊天频道 #faucet-request 输入 \e[42msprinkle ${address}\e[0m"
echo "
+----------------------------------------------------------------------"
echo ''

}

Install_Main
