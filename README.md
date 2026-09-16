# Missing Semester 学习笔记

## Lecture 01: 课程概览与 Shell

包含第一讲课后练习脚本与输出结果记录：

- `lecture-01-shell/semester`: 练习编写的 Shell 脚本（利用 Shebang 与 curl）。
- `lecture-01-shell/last-modified.txt`: 使用管道与 grep 提取的网页修改时间。

### 核心知识点
- **引号与历史扩展**：单引号 `' '` 完全禁用转义与历史扩展（避免 `!` 触发报错）。
- **重定向与权限**：重定向符由当前 Shell 解析，受保护路径需使用 `echo ... | sudo tee ...`。
- **硬件读取**：Linux 系统下通过 `/sys` 虚拟文件系统直接读取传感器数据（如电池 `BAT0/capacity`）。
