#### 目录结构说明
```
1. mydata
用户数据包，打包至 /data/tce/mydata.tgz
运行过程中由tce解压恢复
2. vfat
IMG的boot分区
3. data
IMG的Linux分区
4. mydata/etc/passwd
tc 的uid改为了1000（原uid为1001），初步使用状态正常，暂时不确定对哪些功能有影响。
因为mydata目录解压后的uid都是1000，与tc的uid不一致，导致tc无权限进行任何操作
```

#### 常用命令备忘

```
1. 部分文件需要加可执行标识
git update-index --chmod=+x *.sh
git update-index --chmod=+x ./tinycore/opt/bootlocal.sh
git update-index --chmod=+x ./tinycore/opt/startserialtty
git update-index --chmod=+x ./mydata/home/tc/*.sh
# LF
git config --global core.autocrlf false
git config --global core.autocrlf input
git config --global core.safecrlf true

2. 9.0.3v7.gz
系统文件目录，对应了tinycore目录，对此目录进行调整后，直接使用remaster进行重制即可。
```

#### 设备操作备忘

```
1. 启动热点
先启动dnsmasq，其中修改本机ip为192.168.10.1，并将所有dns解析到了此IP
sudo dnsmasq.sh
再启动热点，SSID： ZK_ABCD  pwd：tbceo123
sudo hostapd hostapd.conf
配置程序就可以监听在默认80端口，等待配置更新确认。确认后重启设备即可。
```

#### 常用软件安装


##### Rabbitmq
```
Compiling rabbitmq worked - but I found an easier solution to get it running, using erlang runtine only. See as well http://www.rabbitmq.com/install-generic-unix.html.
Requirements: erlang.tcz

Download generic linux package, and untar it:
Code: 
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.2.3/rabbitmq-server-generic-unix-3.2.3.tar.gz
tar -zxvf rabbitmq-server-generic-unix-3.2.3.tar.gz
rm -f rabbitmq-server-generic-unix-3.2.3.tar.gz

Remove installation notes and move licence terms to appropriate folder:
Code: 
rm -f rabbitmq_server-3.2.3/INSTALL
mkdir -p rabbitmq_server-3.2.3/share/licences/rabbitmq_server
mv rabbitmq_server-3.2.3/LICENSE* rabbitmq_server-3.2.3/share/licences/rabbitmq_server/

Afterwards store results:
Code:
backup

Installation (I'll put this in bootlocal):
Code:
sudo cp -R rabbitmq_server-3.2.3/* /usr/local/

Start server with Web-Management (Port 15672, guest:guest):
Code: 
sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmq-server

```