# swarmbee节点部署

测试安装环境

ubuntu 20.0.4 2核4g+100gssd 

虽然目前新版bee占用空间更少，理论上应该可以跑4个，不过带宽也会有影响，不需要一台机器带太多，如果是物理机本地服务器可以酌情增加。

另外建议先全局限制下日志大小。这里懒得写了。

1>安装docker和docker-compose

apt upgrade

apt-get update

apt install jq


安装docker

apt install docker

apt install docker.io


安装docker-compose

curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose


然后修改docker-compose文件夹权限


chmod +x /usr/local/bin/docker-compose

2>快速安装

mkdir -p bee && cd bee

wget -q https://raw.githubusercontent.com/ethersphere/bee/master/packaging/docker/docker-compose.yml

wget -q https://raw.githubusercontent.com/ethersphere/bee/master/packaging/docker/env -O .env

#编辑.env

#测试网rpc地址也可以换其他的，这个可能不是很稳定，最好自己注册个infura的免费节点，免费一天十万请求，单跑几个bee基本上不会满，除非你节点特别多带宽也足够

BEE_SWAP_ENDPOINT=https://rpc.slock.it/goerli  

BEE_PASSWORD=#设置一个密码#

BEE_DEBUG_API_ENABLE=true


#编辑docker-compose.yml

BEE_PASSWORD=#设置一个密码与前面的一样#

#img里面bee的版本最好改到目前最新的0.5.2

#如果你是vps最好nat-addr后面写上你的外网地址和对应P2P_ADDR端口

#启动

docker-compose up -d

#查看日志，从提示信息找到你的地址，输入

docker-compose logs -f bee-1

（提示信息示例https://bzz.ethswarm.org/?transaction=buy&amount=10&slippage=30&receiver=0xf1a6c49ff11f0b742db27188ce4faff542062de5%22；这个其中0xf1a6c49ff11f0b742db27188ce4faff542062de就是你的地址，往这个地址弄10个gbzz和少量geth，就会自动启动，建多个节点则每个节点都需要）

#下载cashout脚本 

wget -O cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/7ba05095e0836735f4a648aefe52c584e18e065f/cashout.sh

chmod +x cashout.sh

#查看票据

./cashout.sh

#cashout 可以一天或者几天执行一次，需要注意的是这个脚本的debugapi端口是写死了默认1635的，多个节点的话需要修改脚本。

./cashout.sh cashout-all 5

#启动多个节点

编辑docker-compose.yaml

把3-58行的内容复制粘贴在58行之后。

替换粘贴内容中所有的bee-1为bee-2     clef-1为clef-2；

然后修改API_ADDR、P2P_ADDR、DEBUG_API_ADDR以此为1733，1734和127.0.0.1:1735。

最后在最下面的volumes里添加

  clef-2:
  bee-2:
  
保存退出后。重启：

docker-compose stop

docker-compose up -d 

或者单独启动新的节点

docker-compose up -d clef-2

docker-compose up -d bee-2

如果要添加更多节点，只要重复上面的工作，给新节点唯一的名称和唯一的三个端口就行。
