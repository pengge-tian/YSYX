#!/usr/bin/env bash

# === 练习 1：定制全能 ls 命令 ===
ls -laht --color=auto

# === 练习 4：递归打包 HTML（安全处理文件名空格） ===
find . -type f -name "*.html" -print0 | xargs -0 zip html_archive.zip

# === 练习 5：递归查找全局最新修改的文件 ===
fd --type f -X ls -lt | head -n 1
# 或者使用 find：
# find . -type f -printf '%T+ %p\n' | sort -r | head -n 1
