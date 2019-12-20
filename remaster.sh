#!/bin/bash
# 安装依赖
#  sudo apt-get install dosfstools dump parted kpartx
#

# 目录结构初始化
BASE_PATH=$(cd $(dirname ${0}); pwd)

if [ -d ${BASE_PATH}/target_tinycore ]; then
  rm -rf ${BASE_PATH}/target_tinycore
fi

mkdir ${BASE_PATH}/target_tinycore
WORK=${BASE_PATH}/target_tinycore

# 重制 9.0.3v7.gz
cd ${WORK}

# 解包
sudo zcat ${BASE_PATH}/vfat/9.0.3v7.gz | sudo cpio -i -d

# 覆盖文件
sudo cp -r ${BASE_PATH}/tinycore/* ./

# 打包
find | sudo cpio -o -H newc | sudo gzip -9 > ../core.gz

# copy
cd ..
mv core.gz ${BASE_PATH}/vfat/9.0.3v7.gz

# clear
rm -rf ${WORK:-/tmp/123}