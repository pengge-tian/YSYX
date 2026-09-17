# Lecture 6: 版本控制 (Git / Version Control Systems)

本目录记录 MIT *The Missing Semester of Your CS Education* 第 6 讲（版本控制 Git）的学习记录、底层数据模型分析与课后习题完整解答。

---

## 一、 Git 底层数据模型 (The Data Model)

Git 的底层不是基于文件的版本差异存储，而是基于**不可篡改的对象快照图谱（DAG，有向无环图）**。在 `.git/objects/` 中，所有对象均通过 SHA-1 哈希值进行寻址：

1. **Blob（数据块）**：存储纯文件内容（不存文件名，内容相同则哈希相同，天然去重）。
2. **Tree（目录树）**：模拟目录层级结构，将文件名映射为 Blob 哈希，或将子目录映射为子 Tree 哈希。
3. **Commit（提交快照）**：结构体，包含指向顶级根目录 Tree 的哈希、作者（Author）/提交者信息、时间戳、提交信息（Message）以及父节点指针列表（`parents`）。
4. **引用（References）与 HEAD**：
   - 分支（如 `master`、`main`）本质上是指向某个具体 Commit 对象的**可变便利贴指针**（位于 `.git/refs/heads/`）。
   - `HEAD` 指针表示当前工作区所依托的快照位置。

---

## 二、 课后练习完整解答

### 练习 2 & 3：历史可视化与追查 README 最后修改者

- **命令**：
  ```bash
  git log -1 README.md
  ```
- **解答结果**：
  - **Commit ID**：`52a4c227291f44b196053204081bf63cb0d5203c`
  - **最后修改者 (Author)**：`PurplePulse <qshen98@gmail.com>`
  - **修改时间 (Date)**：`Thu Jul 2 18:02:06 2026 +0800`
  - **提交说明 (Commit Message)**：`docs: improve README wording`

---

### 练习 4：代码行级历史考古 (`git blame` + `git show`)

- **任务**：查找 `_config.yml` 文件中 `collections:` 这一行的最后修改信息。
- **定位代码行与 Commit 哈希**：
  ```bash
  git blame _config.yml | grep collections
  # 输出: a88b4eac (Anish Athalye 2020-01-17 15:26:30 -0500 19) collections:
  ```
- **查看提交详情**：
  ```bash
  git show a88b4eac
  ```
- **解答结果**：
  - **Commit ID**：`a88b4eac326483e29bdac5ee0a39b180948ae7fc`
  - **作者**：`Anish Athalye <me@anishathalye.com>`（MIT 课程主讲教师）
  - **提交说明 (Message)**：`Redo lectures as a collection`

---

### 练习 5：将敏感/大文件从版本历史中彻底抹除

- **问题本质**：单纯执行 `git rm` 只能删除当前工作区文件，敏感文件仍残留于历史快照中，可通过历史检出恢复。必须重写历史图谱。
- **清除命令 (`filter-branch`)**：
  ```bash
  git filter-branch --force --index-filter \
    'git rm --cached --ignore-unmatch secret_token.key' \
    --prune-empty --tag-name-filter cat -- --all
  ```
  - `--index-filter`：直接在暂存区内存级执行，避免逐个检出磁盘文件。
  - `--prune-empty`：若提交节点在剔除该文件后变为空提交，则自动剪枝丢弃该节点。
- **验证**：执行 `git log --oneline`，原密码提交节点被连根移除，后续提交基于新父节点重算哈希值。

---

### 练习 6：暂存箱机制 (`git stash` 与 `git stash pop`)

1. **底层机制**：
   - 执行 `git stash` 时，Git 会在底层创建两个真实的 Commit 节点：
     - 一个记录暂存区快照（`index on master`）
     - 一个记录工作区未提交快照（`WIP on master`）
   - 通过引用 `refs/stash` 指向它们，因此 `git log --all --oneline` 能观察到 stash 提交。
2. **恢复现场**：`git stash pop` 会恢复修改并从 stash 堆栈中弹出记录。
3. **工程应用场景**：
   - 正在开发未完成功能（无法编译）时，突发线上严重缺陷需要切换至 `master` 紧急修复。
   - `git pull` 时因本地未提交的修改冲突被阻止，先 stash 后 pull 再 pop 还原。

---

### 练习 7：配置全局图谱别名 `git graph`

- **配置命令**：
  ```bash
  git config --global alias.graph "log --all --graph --decorate --oneline"
  ```
- **效果**：输入 `git graph` 即可输出直观的分支合并 DAG 有向无环图谱。

---

### 练习 8：全局忽略文件 (`~/.gitignore_global`)

- **配置命令**：
  ```bash
  cat << 'EOF' > ~/.gitignore_global
  .DS_Store
  *~
  *.swp
  *.swo
  .vscode/
  EOF

  git config --global core.excludesfile ~/.gitignore_global
  ```
- **作用**：在所有本地 Git 仓库中自动屏蔽编辑器和操作系统的临时冗余文件。

---

### 练习 9：开源协同协作工作流 (Fork & Pull Request)

1. **Fork**：在 GitHub 上将目标项目复制一份到个人命名空间下。
2. **克隆与开发**：克隆个人 Fork 仓库，基于新特性分支开发并提交。
3. **Pull Request (PR)**：在 GitHub 上向原项目主干发起合并请求，经过 Maintainer 审查（Review）和 CI 测试通过后合入主干。
