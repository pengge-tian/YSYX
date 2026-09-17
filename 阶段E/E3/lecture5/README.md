# Lecture 5: 命令行环境 (Command-line Environment)

本目录记录 MIT *The Missing Semester of Your CS Education* 第 5 讲（命令行环境）的学习记录与课后习题解答。

---

## 1. 任务控制与作业控制 (Job Control)

- **后台运行与挂起**：使用 `&` 后台运行，使用 `Ctrl+Z` 挂起进程，使用 `bg` 唤醒后台执行，`fg` 调回前台。
- **进程管理**：
  - 使用 `pgrep -a <name>` 查找进程 PID 并展示完整命令。
  - 使用 `pkill -f <pattern>` 通过匹配命令行全名杀死进程。
- **等待进程**：
  - `wait <PID>`：等待当前 shell 的子进程退出。
  - `pidwait.sh`：通过 `kill -0 <PID>` 轮询检测任意进程存活状态，在进程退出后返回。

---

## 2. 终端多路复用 (tmux)

- 会话管理：`tmux new -s <name>`, `tmux a -t <name>`, `tmux ls`
- 常用快捷键：默认前缀为 `Ctrl+B`，`"` 上下分屏，`%` 左右分屏，`x` 关闭窗格，`z` 窗格最大化/还原。
- 关键自定义配置（详见 `dotfiles/tmux.conf`）：
  - 开启 256 色色彩支持：`set -g default-terminal "screen-256color"`
  - 消除 Vim 模式切换延迟：`set -s escape-time 0`
  - 开启鼠标支持：`set -g mouse on`

---

## 3. 别名与历史统计 (Aliases)

- 防手抖别名：`alias dc="cd"`
- 高频别名：
  - `alias ysyx="cd ~/Desktop/YSYX/missing-semester"`
  - `alias ga="git add ."`
  - `alias gp="git push"`
  - `alias gs="git status"`
  - `alias ..="cd .."`

---

## 4. 配置文件版本控制 (Dotfiles)

- **目录结构**：`dotfiles/` 下包含 `bashrc_custom`, `vimrc`, `tmux.conf` 以及一键安装脚本 `install.sh`。
- **核心思想**：
  - 使用软链接 `ln -sf` 将仓库中的配置文件映射到 `~/` 根目录下。
  - 修改实时受 Git 追踪管理，换设备或新环境时执行 `./install.sh` 即可一键恢复完整工作环境。
