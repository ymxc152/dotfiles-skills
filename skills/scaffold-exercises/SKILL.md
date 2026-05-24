---
name: scaffold-exercises
description: 创建包含 sections、problems、solutions 和 explainers 的练习目录结构，并通过 linting。当用户想搭建练习、创建练习存根，或设置新课程 section 时使用。
---

# Scaffold Exercises（搭建练习）

创建能通过 `pnpm ai-hero-cli internal lint` 的练习目录结构，然后用 `git commit` 提交。

## Directory naming（目录命名）

- **Sections**：`exercises/` 内的 `XX-section-name/`（例如，`01-retrieval-skill-building`）
- **Exercises**：section 内的 `XX.YY-exercise-name/`（例如，`01.03-retrieval-with-bm25`）
- Section 编号 = `XX`，练习编号 = `XX.YY`
- 名称使用 dash-case（小写，连字符）

## Exercise variants（练习变体）

每个练习至少需要一个以下子文件夹：

- `problem/` - 带 TODOs 的学生工作区
- `solution/` - 参考实现
- `explainer/` - 概念材料，无 TODOs

创建存根时，除非计划另有指定，否则默认使用 `explainer/`。

## Required files（必需文件）

每个子文件夹（`problem/`、`solution/`、`explainer/`）需要一个 `readme.md`，它：

- **非空**（必须有真实内容，即使单行标题也可以）
- 没有损坏的链接

创建存根时，创建一个带标题和描述的最小 readme：

```md
# Exercise Title

Description here
```

如果子文件夹有代码，它还需要一个 `main.ts`（>1 行）。但对于存根，仅 readme 的练习就可以了。

## Workflow（工作流）

1. **Parse the plan（解析计划）** — 提取 section 名称、练习名称和变体类型
2. **Create directories（创建目录）** — 为每个路径 `mkdir -p`
3. **Create stub readmes（创建存根 readme）** — 每个变体文件夹一个 readme，带标题
4. **Run lint（运行 lint）** — `pnpm ai-hero-cli internal lint` 验证
5. **Fix any errors（修复任何错误）** — 迭代直到 lint 通过

## Lint rules summary（Lint 规则摘要）

linter（`pnpm ai-hero-cli internal lint`）检查：

- 每个练习都有子文件夹（`problem/`、`solution/`、`explainer/`）
- `problem/`、`explainer/` 或 `explainer.1/` 中至少有一个存在
- 主子文件夹中存在且非空的 `readme.md`
- 没有 `.gitkeep` 文件
- 没有 `speaker-notes.md` 文件
- readme 中没有损坏的链接
- readme 中没有 `pnpm run exercise` 命令
- 每个子文件夹都需要 `main.ts`，除非仅 readme

## Moving/renaming exercises（移动/重命名练习）

重编号或移动练习时：

1. 使用 `git mv`（而非 `mv`）重命名目录 — 保留 git 历史
2. 更新数字前缀以保持顺序
3. 移动后重新运行 lint

示例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## Example: stubbing from a plan（示例：从计划创建存根）

给定一个计划如：

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

创建：

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

然后创建 readme 存根：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
