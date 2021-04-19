目前是提交gentx阶段.注意，apollo 更新的官方文档提到这对直接参与验证节点的并不会提供任何DSM奖励，主要是为了测试人们的行为。
因此这个可能是无奖励的测试网，或者奖励来源于其他行为或途径。自行判断是否参加。

官方教程.

https://docs.desmos.network/testnets/apollo.html#overview

这里以从未安装过的desmos测试网的举例。

依赖库和go的安装环境配置等，安装过的跳过

# Install git, gcc and make

sudo apt install build-essential --yes

# Install Go with Snap

sudo snap install go --classic

# Export environment variables

echo 'export GOPATH="$HOME/go"' >> ~/.profile

echo 'export GOBIN="$GOPATH/bin"' >> ~/.profile

echo 'export PATH="$GOBIN:$PATH"' >> ~/.profile

source ~/.profile

# 安装节点程序

git clone https://github.com/desmos-labs/desmos.git && cd desmos

# 此处不执行命令，因为新链还没有标注tags
# git fetch --tags --force
# git checkout tags/v0.15.1

make install

---- 选做配置部分开始 ---- 
# 添加seed
nano $HOME/.desmos/config/config.toml

找seeds=这行，修改

seeds = "be3db0fe5ee7f764902dbcc75126a2e082cbf00c@seed-1.morpheus.desmos.network:26656,4659ab47eef540e99c3ee4009ecbe3fbf4e3eaff@seed-2.morpheus.desmos.network:26656,1d9cc23eedb2d812d30d99ed12d5c5f21ff40c23@seed-3.morpheus.desmos.network:26656,67dcef828fc2be3c3bcc19c9542d2b228bd7cff9@seed-4.morpheus.desmos.network:26656,fcf8207fb84a7238089bd0cd8db994e0af9016b6@seed-5.morpheus.desmos.network:26656"

找persistent_peers = ""，修改

persistent_peers = "1d9cc23eedb2d812d30d99ed12d5c5f21ff40c23@seed-3.morpheus.desmos.network:26656,bdd98ec74fe56146f08e886239e52373f6821ce3@51.15.113.208:26656,25490afe8d5b6bfe065f1dd8154f420f050fbb57@95.216.148.253:26656"

# 修改区块裁剪策略
找到 ~/.desmos/config/app.toml 文件 修改pruning = "default" 为 pruning = "everything"

# Reset the node:
desmos unsafe-reset-all

# 配置后台启动
运行如下命令

tee /etc/systemd/system/desmos.service > /dev/null <<EOF  
[Unit]
Description=Desmos Full Node
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/desmos start
Restart=always
RestartSec=10
LimitNOFILE=4096 # To compensate the "Too many open files" issue.

[Install]
WantedBy=multi-user.target
EOF

启用服务
systemctl enable desmos

启动服务
systemctl start desmos

查看服务状态
systemctl status desmos

desmos status | jq

tail -100f /var/log/syslog

---- 选做配置部分结束 ---- 

# Initialize your node

desmos init <Your moniker>
  
# 下载创世文件 

rm ~/.desmos/config/genesis.json

curl https://raw.githubusercontent.com/desmos-labs/morpheus/master/morpheus-apollo-1/genesis.json > ~/.desmos/config/genesis.json

# 如果没有创建过钱包需要先创建钱包，或者通过助记词导入钱包。
# 添加一个钱包（<key_name> 是自定义的）记录助记词，记下地址

desmos keys add <key_name> --keyring-backend "os"

desmos add-genesis-account <key_name> 10000000udaric 

desmos gentx <key_name> 1000000udaric --chain-id=morpheus-apollo-1 \
    --moniker="<Your validator moniker>" \
    --commission-max-change-rate=0.01 \
    --commission-max-rate=1.0 \
    --commission-rate=0.10 \
    --details="..." \
    --security-contact="..." \
    --website="..."

会得到一条这样的信息：Genesis transaction written to "/home/user/.desmos/config/gentx/gentx-6b1fe44615aa1ac9b0dfc637d1a33fd63de2a05e.json"

# 你需要fork 代码并再本地拉到本地，cp文件到自己的仓库目录下，然后pull，再在github上提交pr
# fork 代码后 下载到本地
git clone https://github.com/<Your GitHub username>/morpheus.git 
cd morpheus
cp ~/.desmos/config/genesis.json morpheus-apollo-1/ 
cp /home/user/.desmos/config/gentx/gentx-<你前面获得的那条json>.json morpheus-apollo-1/gentxs/
  
git add . 
git commit -m "<Your commit message>"
git push
  
#最后进行pr即可。然后需要等待主网启动
