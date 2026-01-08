#!/bin/bash

# =================================================================
# 脚本名称: install_node_pnpm.sh
# 适用系统: Ubuntu 24.04 (及其他基于 Debian 的系统)
# 脚本功能: 自动化安装 NVM -> Node.js -> pnpm
# 执行命令: 
#   方式 1 (推荐): chmod +x install_node_pnpm.sh && ./install_node_pnpm.sh
#   方式 2 (无需改权限): bash install_node_pnpm.sh
# 注意事项: 请勿使用 sudo 运行此脚本，因为 NVM 推荐用户级安装。
# =================================================================

# 检查是否以 root 运行 (NVM 建议非 root)
if [ "$EUID" -eq 0 ]; then
  echo "警告: NVM 通常建议以普通用户身份安装，而不是 root。"
  echo "如果你确定要为 root 用户安装，请继续。否则请按 Ctrl+C 退出。"
  sleep 3
fi

echo "--- 正在开始 Node.js 环境安装流程 ---"

# 1. 安装基础依赖
echo "1. 正在检查并安装基础依赖 (curl)..."
if ! command -v curl &> /dev/null; then
    sudo apt update && sudo apt install -y curl
fi

# 2. 安装 NVM (Node Version Manager)
echo "2. 正在安装 NVM..."
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then
    echo "提示: NVM 目录已存在，跳过安装。"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# 加载 NVM 环境 (无需重启终端即可使用)
echo "3. 正在加载 NVM 环境..."
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# 3. 安装 Node.js (最新 LTS 版本)
echo "4. 正在通过 NVM 安装 Node.js (LTS)..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# 4. 安装 pnpm
echo "5. 正在安装 pnpm..."
curl -fsSL https://get.pnpm.io/install.sh | sh -

# 5. 验证安装版本
echo "6. 验证安装结果："
echo -n "Node.js 版本: " && node -v
echo -n "NPM 版本: " && npm -v
# 提示: pnpm 安装后可能需要刷新 PATH 才能直接运行 pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

if command -v pnpm &> /dev/null; then
    echo -n "pnpm 版本: " && pnpm -v
else
    echo "提示: pnpm 已安装，但可能需要运行 'source ~/.bashrc' 或重新进入终端以完全生效。"
fi

echo ""
echo "--- Node.js 环境安装脚本执行完毕 ---"
echo "提示: 建议运行 'source ~/.bashrc' 以确保所有环境变量正确加载。"
