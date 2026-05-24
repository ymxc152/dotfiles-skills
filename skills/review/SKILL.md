---
name: review
description: 从固定点（commit、branch、tag 或 merge-base）开始审查更改，沿两个轴进行——Standards（代码是否遵循本仓库记录的编码标准？）和 Spec（代码是否符合原始 issue/PRD 的要求？）。两个审查作为并行 sub-agents 运行并并排报告。当用户想审查 branch、PR、进行中的更改，或要求 "review since X" 时使用。
---

# Review（审查）

对用户提供的固定点与 `HEAD` 之间的 diff 进行双轴审查：

- **Standards** — 代码是否符合本仓库记录的编码标准？
- **Spec** — 代码是否忠实实现了原始 issue / PRD / spec？

两个轴作为**并行 sub-agents** 运行，这样它们不会互相污染上下文，然后本 skill 汇总它们的发现。

issue tracker 应该已经提供给你——如果 `docs/agents/issue-tracker.md` 缺失，运行 `/setup-matt-pocock-skills`。

## Process（流程）

### 1. Pin the fixed point（固定比较点）

用户说的固定点就是固定点——commit SHA、branch 名称、tag、`main`、`HEAD~5` 等。不要有自己的意见；直接传递。如果他们没有指定，问："Review against what — a branch, a commit, or `main`?" 在得到答案之前不要继续。

捕获 diff 命令一次：`git diff <fixed-point>...HEAD`（三个点，所以比较是针对 merge-base 的）。同时通过 `git log <fixed-point>..HEAD --oneline` 记录 commits 列表。

### 2. Identify the spec source（识别 spec 来源）

按以下顺序查找原始 spec：

1. commit messages 中的 issue 引用（`#123`、`Closes #45`、GitLab `!67` 等）——通过 `docs/agents/issue-tracker.md` 中的工作流获取。
2. 用户作为参数传递的路径。
3. `docs/`、`specs/` 或 `.scratch/` 下与 branch 名称或功能匹配的 PRD/spec 文件。
4. 如果什么都没找到，问用户 spec 在哪里。如果他们说没有，**Spec** sub-agent 将跳过并报告 "no spec available"。

### 3. Identify the standards sources（识别标准来源）

仓库中任何记录代码应该如何写的内容。常见位置：

- `CLAUDE.md`、`AGENTS.md`
- `CONTRIBUTING.md`
- `CONTEXT.md`、`CONTEXT-MAP.md`、每个上下文的 `CONTEXT.md` 文件
- `docs/adr/`（架构决策是标准）
- `.editorconfig`、`eslint.config.*`、`biome.json`、`prettier.config.*`、`tsconfig.json`（机器强制执行的标准——记录它们但不要重新检查工具已经检查的内容）
- 仓库根目录或 `docs/` 下的任何 `STYLE.md`、`STANDARDS.md`、`STYLEGUIDE.md` 或类似文件

收集文件列表。**Standards** sub-agent 将阅读它们。

### 4. Spawn both sub-agents in parallel（并行生成两个 sub-agents）

发送一条包含两个 `Agent` tool 调用的消息。两者都使用 `general-purpose` subagent。

**Standards sub-agent prompt** — 包含：

- 完整的 diff 命令和 commit 列表。
- 你在步骤 3 中找到的标准来源文件列表。
- 简报："Read the standards docs. Then read the diff. Report — per file/hunk where relevant — every place the diff violates a documented standard. Cite the standard (file + the rule). Distinguish hard violations from judgement calls. Skip anything tooling enforces. Under 400 words."

**Spec sub-agent prompt** — 包含：

- diff 命令和 commit 列表。
- spec 的路径或获取的内容。
- 简报："Read the spec. Then read the diff. Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

如果 spec 缺失，跳过 Spec sub-agent 并在最终报告中注明。

### 5. Aggregate（汇总）

在两个报告下以 `## Standards` 和 `## Spec` 标题 verbatim 或轻微清理地展示。不要**合并或重新排序发现——两个轴是故意分开的，以便用户可以独立看到它们。

以一行摘要结束：每个轴的发现总数，以及标记的最严重单个 issue（如果有）。

## Why two axes（为什么两个轴）

一个更改可以通过一个轴但失败另一个：

- 遵循每个标准但实现了错误的东西的代码 → **Standards pass, Spec fail.**
- 精确做了 issue 要求的事但打破了项目约定的代码 → **Spec pass, Standards fail.**

分开报告它们可以防止一个轴掩盖另一个。
