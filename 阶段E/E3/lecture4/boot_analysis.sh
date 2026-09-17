#!/usr/bin/env bash

echo "=== 练习 4: 最近 10 次开机时间统计 ==="
journalctl -q | grep "systemd\[1\]: Startup finished in" | tail -n 10 \
  | sed -E 's/.*= ([0-9.]+)s\./\1/' \
  | python3 -c '
import sys, statistics as s
times = [float(x.strip()) for x in sys.stdin if x.strip()]
if times:
    print(f"数据总数: {len(times)} 次")
    print(f"平均开机时间: {s.mean(times):.2f} 秒")
    print(f"中位数时间:   {s.median(times):.2f} 秒")
    print(f"最长开机耗时: {max(times):.2f} 秒")
'

echo -e "\n=== 练习 5: 对比前 3 次开机日志中的不同部分 (提取前 5 条差异) ==="
for b in 0 -1 -2; do
    journalctl -b $b -q -o cat | sort -u
done | sort | uniq -c | awk '$1 != 3 { print }' | head -n 5
