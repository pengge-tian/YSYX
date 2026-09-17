#!/usr/bin/env bash

echo "=== 1. 拉取天气数据并清洗为两列 (最高温 最低温) ==="
curl -s "https://api.open-meteo.com/v1/forecast?latitude=39.9&longitude=116.4&daily=temperature_2m_max,temperature_2m_min&timezone=auto" \
  | python3 -c '
import sys, json
data = json.load(sys.stdin)["daily"]
for high, low in zip(data["temperature_2m_max"], data["temperature_2m_min"]):
    print(f"{high} {low}")
' > temps.txt

cat temps.txt

echo -e "\n=== 2. 一条命令计算第 1 列的最小值和最大值 ==="
cat temps.txt | awk '{print $1}' | sort -n | sed -e 1b -e '$!d'

echo -e "\n=== 3. 一条命令计算两列温差绝对值的总和 ==="
cat temps.txt | awk '{ diff = $1 - $2; sum += (diff >= 0 ? diff : -diff) } END { print "温差绝对值总和:", sum }'
