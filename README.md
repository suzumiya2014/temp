# swarmbee节点部署

测试安装环境
ubuntu 20.0.4 2核4g+100gssd 
虽然目前新版bee占用空间更少，理论上应该可以跑4个，不过带宽也会有影响，不需要一台机器带太多，如果是物理机本地服务器可以酌情增加。
另外建议先全局限制下日志大小。这里懒得写了。

1>安装docker和docker-compose
apt-get update

apt upgrade


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
BEE_SWAP_ENDPOINT=https://rpc.slock.it/goerli       #也可以换其他的，最好自己注册个infura的免费节点，免费一天十万请求，单跑几个bee基本上不会满，除非你节点特别多带宽也足够
BEE_PASSWORD=#设置一个密码#
BEE_DEBUG_API_ENABLE=true

#编辑docker-compose.yml
BEE_PASSWORD=#设置一个密码与前面的一样#
#img里面bee的版本最好改到目前最新的0.5.2
#如果你是vps最好nat-addr后面写上你的外网地址和对应P2P_ADDR端口

#启动
docker-compose up -d
查看日志，从提示信息找到你的地址，打开他
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
严格参考官方文档原话即可（以下是google翻译和原版）
这是很容易通过增加更多的服务来运行搬运工撰写多蜜蜂节点docker-compose.yaml 要做到这一点，打开docker-compose.yaml，复制线3-58和过去的这条线58在复制的行之后，替换出现的所有bee-1带bee-2，clef-1与clef-2和调整API_ADDR，并P2P_ADDR并DEBUG_API_ADDR分别1733，1734而127.0.0.1:1735 最后，添加新配置的服务下volumes（最后几行），这样它看起来像：

音量：
  谱号-1：
  蜂-1：
  蜂2：
  谱号-2：
如果要创建两个以上的节点，只需重复上述过程，确保为蜜蜂和谱号服务保留唯一的名称并更新端口

It is easy to run multiple bee nodes with docker compose by adding more services to docker-compose.yaml To do so, open docker-compose.yaml, copy lines 3-58 and past this after line 58. In the copied lines, replace all occurences of bee-1 with bee-2, clef-1 with clef-2 and adjust the API_ADDR and P2P_ADDR and DEBUG_API_ADDR to respectively 1733, 1734 and 127.0.0.1:1735 Lastly, add your newly configured services under volumes (last lines), such that it looks like:

volumes:
  clef-1:
  bee-1:
  bee-2:
  clef-2:
If you want to create more than two nodes, simply repeat the process above, ensuring that you keep unique name for your bee and clef services and update the ports
