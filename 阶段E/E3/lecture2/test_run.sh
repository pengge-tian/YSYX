#! /usr/bin/env bash
count=0
log_file="debug_output.log"

while true; do
	((count++))
	./buggy.sh > "$log_file" 2>&1
	if [[ $? -ne 0 ]]; then
		echo "-------------------"
		echo "成功抓取Bug！一共运行了 $count次"
		echo "-------------------"
		echo "退出日至:"
		cat "$log_file"
		break
	fi
done
