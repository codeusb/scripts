#!/bin/bash

# =================================================================
# 脚本名称: install_nginx.sh
# 适用系统: Ubuntu 24.04 (及其他基于 Debian 的系统)
# 脚本功能: 自动化安装 Nginx 并设置基础服务
# 执行命令: 
#   方式 1 (推荐): chmod +x install_nginx.sh && sudo ./install_nginx.sh
#   方式 2 (无需改权限): sudo bash install_nginx.sh
# =================================================================

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

echo "--- 正在开始 Nginx 安装流程 ---"

# 1. 更新系统包列表
# 使用 -y 自动确认，避免交互
echo "1. 正在更新系统包列表..."
apt update && apt upgrade -y

# 2. 安装 Nginx
echo "2. 正在安装 Nginx..."
apt install nginx -y

# 3. 验证安装版本
echo "3. Nginx 安装完成，版本信息："
nginx -v

# 4. 启动并启用 Nginx 服务
echo "4. 正在启动并设置 Nginx 开机自启..."
systemctl start nginx
systemctl enable nginx

# 5. 检查服务状态
echo "5. Nginx 服务当前状态："
systemctl status nginx --no-pager -l

echo ""
echo "--- Nginx 安装脚本执行完毕 ---"
echo "提示: Nginx 默认配置文件位于 /etc/nginx/sites-available/default"
echo "你可以使用 'sudo vim /etc/nginx/sites-available/default' 进行手动配置。"
