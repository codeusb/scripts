#!/bin/bash

# =================================================================
# 脚本名称: install_docker.sh
# 适用系统: Ubuntu 24.04 (及其他基于 Debian 的系统)
# 脚本功能: 自动化安装 Docker 并配置国内加速镜像 (深度优化版)
# 执行命令: 
#   方式 1: chmod +x install_docker.sh && sudo ./install_docker.sh
#   方式 2: sudo bash install_docker.sh
# =================================================================

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

echo "--- 正在开始 Docker 深度优化版安装流程 ---"

# 1. 更新系统包列表并安装必要依赖
echo "1. 正在更新系统包列表并安装必要依赖..."
apt update && apt upgrade -y
apt install -y ca-certificates curl gnupg lsb-release

# 2. 添加 Docker 的官方 GPG 密钥 (使用 modern 路径)
echo "2. 正在添加 Docker 官方 GPG 密钥..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
chmod a+r /etc/apt/keyrings/docker.gpg

# 3. 设置 Docker 仓库
echo "3. 正在设置 Docker 仓库..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

# 4. 安装 Docker 组件 (包含 Compose V2 和 Buildx)
echo "4. 正在安装 Docker Engine, CLI, containerd 和插件..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. 配置 Docker 镜像加速器 (针对国内网络环境深度优化)
echo "5. 正在配置 Docker 镜像加速器..."
mkdir -p /etc/docker
cat <<EOF | tee /etc/docker/daemon.json > /dev/null
{
  "registry-mirrors": [
    "https://ccr.ccs.tencentyun.com",
    "https://docker.rainbond.cc",
    "https://elastic.m.daocloud.io",
    "https://docker.m.daocloud.io",
    "https://gcr.m.daocloud.io",
    "https://ghcr.m.daocloud.io",
    "https://k8s-gcr.m.daocloud.io",
    "https://k8s.m.daocloud.io",
    "https://mcr.m.daocloud.io",
    "https://nvcr.m.daocloud.io",
    "https://quay.m.daocloud.io"
  ]
}
EOF

# 6. 重启 Docker 服务 以应用配置
echo "6. 正在重启 Docker 服务并设置开机自启..."
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

# 7. 验证安装版本
echo "7. Docker 安装完成，版本信息："
docker --version
docker compose version

# 8. 检查服务器加速器状态
echo "8. Docker 服务当前状态："
systemctl status docker --no-pager -l

echo ""
echo "--- Docker 安装脚本执行完毕 ---"
echo "提示: 你可以使用 'sudo docker info | grep -i mirror' 验证加速器是否生效。"
echo "提示: 若要允许非 root 用户运行 Docker，请执行: sudo usermod -aG docker \$USER (需重新登录生效)。"
