#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/172.16.0.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 目标目录
TARGET_DIR="target/linux/x86/image"

# 要修改的文件列表
FILES=("grub-efi.cfg" "grub-iso.cfg" "grub-pc.cfg")

# 遍历文件列表并进行修改
for FILE in "${FILES[@]}"; do
    FILE_PATH="$TARGET_DIR/$FILE"
    if [ -f "$FILE_PATH" ]; then
        sed -i 's/@CMDLINE@ noinitrd/@CMDLINE@ cgroup_enable=memory swapaccount=1 noinitrd/g' "$FILE_PATH"
        echo "Modified $FILE_PATH"
    else
        echo "File $FILE_PATH does not exist"
    fi
done

./scripts/feeds update -a
./scripts/feeds install -a