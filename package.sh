#!/bin/bash
# 安装依赖
#  sudo apt-get install dosfstools dump parted kpartx
#

# 目录结构初始化
BASE_PATH=$(cd $(dirname ${0}); pwd)

if [ -d ${BASE_PATH}/target ]; then
  rm -rf ${BASE_PATH}/target
fi

mkdir ${BASE_PATH}/target
WORK=${BASE_PATH}/target

# 打包mydata
if [ -f ${BASE_PATH}/data/tce/mydata.tgz ]; then
  rm ${BASE_PATH}/data/tce/mydata.tgz
fi
tar --owner=1001 --group=50 -cvf ${BASE_PATH}/data/tce/mydata.tgz -C ${BASE_PATH}/mydata/ etc home


# 创建350mb的文件，大概剩余30M的空间
dd if=/dev/zero of=${WORK}/raspberrypi.img bs=1M count=350

# 格式化分区
parted ${WORK}/raspberrypi.img --script -- mklabel msdos
#45MB
parted ${WORK}/raspberrypi.img --script -- mkpart primary fat32 8192s 184319s
#135MB
parted ${WORK}/raspberrypi.img --script -- mkpart primary ext4 184320s -1

# 挂载
loopdevice=`sudo losetup -f --show ${WORK}/raspberrypi.img`
device=`sudo kpartx -va $loopdevice | sed -E 's/.*(loop[0-9]+)p.*/\1/g' | head -1`
device="/dev/mapper/${device}"
partBoot="${device}p1"
partRoot="${device}p2"

# 分区
sudo mkfs.vfat $partBoot
sudo mkfs.ext4 $partRoot

# 复制备份
mkdir ${WORK}/p1
mkdir ${WORK}/p2
sudo mount -t vfat $partBoot ${WORK}/p1
sudo mount -t ext4 $partRoot ${WORK}/p2

sudo cp -rfp ${BASE_PATH}/vfat/* ${WORK}/p1
# ext4用cp
sudo cp -rfp ${BASE_PATH}/data/* ${WORK}/p2
# ext4使用dump
#cd ${WORK}/p2
#sudo dump -h 0 -0af - ${BASE_PATH}/data/* | sudo restore -rf -
#cd

sudo umount ${WORK}/p1
sudo umount ${WORK}/p2

# 卸载
sudo kpartx -d $loopdevice
sudo losetup -d $loopdevice