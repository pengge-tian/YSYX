#!/usr/bin/env bash
set -e
# 获取当前 install.sh 脚本所在的绝对路径
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "==> 开始自动安装 Dotfiles 配置..."
# 1. 软链接 Vim 配置
ln -sf "${DOTFILES_DIR}/vimrc" ~/.vimrc
echo "[✓] 已建立链接: ~/.vimrc -> ${DOTFILES_DIR}/vimrc"
# 2. 软链接 Tmux 配置
ln -sf "${DOTFILES_DIR}/tmux.conf" ~/.tmux.conf
echo "[✓] 已建立链接: ~/.tmux.conf -> ${DOTFILES_DIR}/tmux.conf"
# 3. 软链接自定义 Bash 配置
ln -sf "${DOTFILES_DIR}/bashrc_custom" ~/.bashrc_custom
echo "[✓] 已建立链接: ~/.bashrc_custom -> ${DOTFILES_DIR}/bashrc_custom"
# 4. 确保系统的 ~/.bashrc 会自动加载自定义配置（安全无损，不破坏 Ubuntu 原生配置）
if ! grep -q "source ~/.bashrc_custom" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# 自动加载 YSYX 自定义 Dotfiles 配置" >> ~/.bashrc
    echo "[ -f ~/.bashrc_custom ] && source ~/.bashrc_custom" >> ~/.bashrc
    echo "[✓] 已在 ~/.bashrc 中加入自动加载规则"
else
    echo "[!] ~/.bashrc 中已包含加载规则，跳过写入"
fi
echo "==> [成功] 所有配置文件已通过软链接就位！"
