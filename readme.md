# install_nginx.sh

关于执行该脚本的两种方式及其原理说明：

## 1. 执行方式

### 方式 A：赋予执行权限后运行（推荐）
这是 Linux 中最标准的脚本运行方式。
```bash
chmod +x install_nginx.sh
sudo ./install_nginx.sh
```

### 方式 B：直接通过解释器运行（无需改权限）
如果你不想修改文件权限，可以指定使用 `bash` 来读取并执行脚本内容。
```bash
sudo bash install_nginx.sh
```

---

## 2. 为什么通常需要 `chmod +x`？

在 Linux 系统中，文件是否能被直接运行（如 `./script_name`）取决于它的**权限位**（Permission Bits）。

*   **安全性设计**：Linux 默认新建的文件是不具备“可执行”权限的，这是为了防止意外运行了恶意程序。
*   **权限解析**：当你输入 `./install_nginx.sh` 时，系统会检查该文件是否有 `x` (executable) 标志。如果没有，内核会拒绝执行并返回 `Permission denied`。
*   **shebang (#!)**：当文件有了执行权限后，系统会读取脚本第一行的 `#!/bin/bash`，知道该调用哪个程序来处理它。

## 3. 为什么 `sudo bash` 可以直接运行？

当你使用 `sudo bash install_nginx.sh` 时：
*   你并不是在“执行”脚本文件，而是在**执行 `bash` 程序**。
*   `install_nginx.sh` 仅仅是作为 `bash` 程序的一个**参数**（输入文件）被读取。
*   只要你对该文件有“读取”权限，`bash` 就能获取其中的代码逻辑并运行。

## 总结建议
*   如果你是脚本的长期维护者，建议使用 `chmod +x` 赋予权限，这样以后只需输入 `./文件名` 即可，更加直观。

---

# install_docker.sh

该脚本用于在 Ubuntu/Debian 系统上自动化安装 Docker 环境并配置国内镜像加速器。

## 1. 安装内容
- **Docker Engine**：核心运行环境。
- **Docker Compose V2**：现代容器编排工具（命令为 `docker compose`）。
- **Docker Buildx**：下一代镜像构建工具。
- **镜像加速器**：包含腾讯云、DaoCloud 等多个国内镜像源，解决拉取镜像慢的问题。

## 2. 执行方式

### 方式 A：推荐方式
```bash
chmod +x install_docker.sh
sudo ./install_docker.sh
```

### 方式 B：临时运行
```bash
sudo bash install_docker.sh
```

## 3. 验证安装
安装完成后，可以使用以下命令验证：

---

# install_node_pnpm.sh

该脚本用于在 Ubuntu/Debian 系统上快速搭建 Node.js 开发环境。

## 1. 安装内容
- **NVM (Node Version Manager)**：用于管理多个 Node.js 版本的工具。
- **Node.js (LTS)**：通过 NVM 自动安装并设置最新的长期支持版本。
- **pnpm**：高效的现代包管理器。

## 2. 执行方式

### 方式 A：推荐方式
```bash
chmod +x install_node_pnpm.sh
./install_node_pnpm.sh
```

### 方式 B：直接执行
```bash
bash install_node_pnpm.sh
```

> [!NOTE]
> 建议以普通用户身份运行此脚本。安装完成后，请执行 `source ~/.bashrc` 或重新连接终端以激活环境变量。

## 3. 验证安装
```bash
nvm --version
node -v
pnpm -v
```
