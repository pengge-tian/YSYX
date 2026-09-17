#!/usr/bin/env bash
DICT="/usr/share/dict/words"

echo "=== 1. 包含至少 3 个 a 且不以 's 结尾的单词数量 ==="
tr '[:upper:]' '[:lower:]' < "$DICT" | grep -v "'s$" | grep -E '(.*a){3}' | wc -l

echo -e "\n=== 2. 出现频率前三的词尾两字母组合 ==="
tr '[:upper:]' '[:lower:]' < "$DICT" | grep -v "'s$" | grep -E '(.*a){3}' \
  | sed -E 's/.*(..)$/\1/' | sort | uniq -c | sort -nr | head -n 3

echo -e "\n=== 3. 词尾两字母组合总数 ==="
tr '[:upper:]' '[:lower:]' < "$DICT" | grep -v "'s$" | grep -E '(.*a){3}' \
  | sed -E 's/.*(..)$/\1/' | sort -u | wc -l

echo -e "\n=== 4. 未出现过的两字母组合前 10 个示例 ==="
comm -23 <(printf '%s\n' {a..z}{a..z}) \
         <(tr '[:upper:]' '[:lower:]' < "$DICT" | grep -v "'s$" | grep -E '(.*a){3}' | sed -E 's/.*(..)$/\1/' | sort -u) \
  | head -n 10
