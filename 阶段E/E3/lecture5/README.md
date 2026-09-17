# Lecture 5: 命令行环境 (Command-line Environment)

本目录记录 MIT *The Missing Semester of Your CS Education* 第 5 讲（命令行环境）的学习记录、核心实验脚本与课后习题完整解答。

---

## 1. 任务控制与作业控制 (Job Control)

- **后台运行与挂起**：使用 `&` 后台运行，使用 `Ctrl+Z` 挂起进程，使用 `bg` 唤醒后台执行，`fg` 调回前台。
- **进程管理**：
  - 使用 `pgrep -a <name>` 查找进程 PID 并展示完整命令行参数。
  - 使用 `pkill -f <pattern>` 通过精确匹配命令行完整内容结束进程。
- **等待进程**：
  - `wait <PID>`：等待当前 shell 的子进程退出。
  - `pidwait.sh`：通过 `kill -0 <PID>` 轮询检测任意进程存活状态，在进程退出后立即返回（详见本目录下 `pidwait.sh`）。

---

## 2. 终端多路复用 (tmux)

- **会话管理**：`tmux new -s <name>`, `tmux a -t <name>`, `tmux ls`。
- **快捷键**：默认前缀为 `Ctrl+B`，`"` 上下分屏，`%` 左右分屏，`x` 关闭窗格，`z` 窗格最大化/还原。
- **关键自定义配置**（详见 `dotfiles/tmux.conf`）：
  - 开启 256 真实色彩支持：`set -g default-terminal "screen-256color"`（防止 Vim 配色偏色发灰）。
  - 消除按键延迟：`set -s escape-time 0`（彻底消除 Vim 在普通模式与插入模式切换时的半秒卡顿）。
  - 开启鼠标支持：`set -g mouse on`。

---

## 3. 别名与历史统计 (Aliases)

- **防手抖别名**：`alias dc="cd"`
- **高频统计别名**（基于 `history | awk ...` 分析得出）：
  - `alias ysyx="cd ~/Desktop/YSYX/missing-semester"`
  - `alias ga="git add ."`
  - `alias gp="git push"`
  - `alias gs="git status"`
  - `alias ..="cd .."`
  - `alias ll="ls -la --color=auto"`

---

## 4. 配置文件版本控制 (Dotfiles)

- **目录组织**：`dotfiles/` 包含 `bashrc_custom`, `vimrc`, `tmux.conf`。
- **自动化安装**：编写了 `install.sh` 脚本，基于 `ln -sf` 为用户家目录自动建立软链接，修改即时受 Git 追踪管理；并通过安全检测规则无损接入 `~/.bashrc`。
- **自定义 `$PS1`**：定制了带时间戳、绿色用户名和蓝色工作目录的高可读性彩色提示符。

---

## 5. 远端设备与 SSH 进阶实战 (Remote Machines & SSH)

- **现代化密钥生成**：
  ```bash
  ssh-keygen -o -a 100 -t ed25519
  ```
  - `-t ed25519`：采用爱德华曲线算法，相较 RSA 更快、更紧凑且更安全。
  - `-a 100`：设置 100 轮 KDF 衍生计算，成倍增加抗暴力破解难度。
  - `-o`：采用新版 OpenSSH 密钥存储格式。
- **SSH 客户端别名与端口转发配置 (`~/.ssh/config`)**：
  ```text
  Host vm
      User wangpeng
      HostName 127.0.0.1
      IdentityFile ~/.ssh/id_ed25519
      LocalForward 9999 localhost:8888
  ```
- **公钥安全分发**：
  ```bash
  ssh-copy-id vm
  ```
  自动将公钥写入服务器端 `~/.ssh/authorized_keys`，实现非对称加密免密登录。
- **本地端口转发验证 (Local Port Forwarding)**：
  - 远端仅在 8888 端口运行 `python3 -m http.server 8888`。
  - 本地直接通过 `curl -I http://localhost:9999` 成功穿透访问，请求被 SSH 加密隧道安全转达至服务端的 8888 端口。
- **服务端安全加固 (`/etc/ssh/sshd_config`)**：
  - 禁用密码登录：`PasswordAuthentication no`（黑客无法进行弱口令字典爆破）。
  - 禁用 root 远程登录：`PermitRootLogin no`（降低管理员特权被直接击穿的风险）。
  - 验证效果：`ssh -o PubkeyAuthentication=no vm` 强制密码登录被服务器直接拒绝（`Permission denied (publickey)`）。

---

## 6. 课后附加题解答

1. **Mosh（Mobile Shell）漫游与抗网络丢包/切换**：
   - SSH 基于 TCP，网络中断或 IP 变动会导致连接冻结中断（`Broken pipe`）。
   - Mosh 基于 UDP 与状态同步协议（SSP）。即使断开网络连接或切换 Wi-Fi / 热点，Mosh 不会掉线，网络恢复后会瞬间自动重连，且本地输入即时回显零延迟。
2. **后台静默端口转发命令**：
   ```bash
   ssh -f -N -L 9999:localhost:8888 vm
   # 若已在 ~/.ssh/config 中配置了 LocalForward，可简写为：
   ssh -f -N vm
   ```
   - `-N`：不执行远程命令，仅用于端口转发。
   - `-f`：在认证完成后立即转入后台静默运行，释放当前终端。
