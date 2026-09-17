#!/usr/bin/env bash
# ==============================================================================
# 课后习题: pidwait
# 功能: 等待指定 PID 的进程结束，进程退出后立即返回
# 用法: ./pidwait.sh <PID>
# ==============================================================================

pidwait() {
    local target_pid=$1
    if [[ -z "$target_pid" ]]; then
        echo "用法: pidwait <PID>" >&2
        return 1
    fi

    # kill -0 不会发送终止信号，仅用于检测进程是否存在
    while kill -0 "$target_pid" 2>/dev/null; do
        sleep 1
    done

    echo "==> 进程 $target_pid 已退出。"
}

pidwait "$@"
