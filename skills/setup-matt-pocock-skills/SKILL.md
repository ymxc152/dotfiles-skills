---
name: setup-matt-pocock-skills
description: 在 AGENTS.md/CLAUDE.md 中设置 `## Agent skills` 块和 `docs/agents/`，以便 engineering skills 知道该仓库的 issue tracker（GitHub 或本地 markdown）、分类标签词汇和领域文档布局。在首次使用 `to-issues`、`to-prd`、`triage`、`diagnose`、`tdd`、`improve-codebase-architecture` 或 `zoom-out` 之前运行——或如果这些 skills 似乎缺少关于 issue tracker、分类标签或领域文档的上下文时运行。
disable-model-invocation: true
---

# Setup Matt Pocock's Skills（设置 Matt Pocock 的 Skills）

搭建 engineering skills 假设的每仓库配置：

- **Issue tracker** — issues 在哪里（默认 GitHub；本地 markdown 也开箱即用支持）
- **Triage labels** — 五个规范分类角色使用的字符串
- **Domain docs** — `CONTEXT.md` 和 ADR 在哪里，以及阅读它们的消费规则

这是一个 prompt-driven skill，不是确定性脚本。探索、展示你发现的内容、与用户确认，然后写入。

## Process（流程）

### 1. Explore（探索）

查看当前仓库以了解其起始状态。阅读任何存在的内容；不要假设：

- `git remote -v` 和 `.git/config` — 这是 GitHub 仓库吗？哪一个？
- 仓库根目录的 `AGENTS.md` 和 `CLAUDE.md` — 两者中是否存在任何一个？其中是否已有 `## Agent skills` 部分？
- 仓库根目录的 `CONTEXT.md` 和 `CONTEXT-MAP.md`
- `docs/adr/` 和任何 `src/*/docs/adr/` 目录
- `docs/agents/` — 本 skill 的先前输出是否已经存在？
- `.scratch/` — 表明本地 markdown issue tracker 约定已经在使用的迹象

### 2. Present findings and ask（展示发现并询问）

总结存在什么和缺少什么。然后一次一个地引导用户完成三个决策——展示一个部分，得到用户的答案，然后移动到下一个。不要一次性倾倒所有三个。

假设用户不知道这些术语的含义。每个部分以简短的解释器开头（它是什么、为什么这些 skills 需要它、如果他们选择不同会有什么变化）。然后展示选择和默认值。

**Section A — Issue tracker.**

> 解释器："Issue tracker" 是这个仓库 issues 所在的地方。`to-issues`、`triage`、`to-prd` 和 `qa` 等 skills 会从中读取并写入其中——它们需要知道是调用 `gh issue create`、在 `.scratch/` 下写入 markdown 文件，还是遵循你描述的其他工作流。选择你实际追踪这个仓库工作的地方。

默认姿态：这些 skills 为 GitHub 设计。如果 `git remote` 指向 GitHub，提议那个。如果 `git remote` 指向 GitLab（`gitlab.com` 或自托管主机），提议 GitLab。否则（或如果用户偏好），提供：

- **GitHub** — issues 位于仓库的 GitHub Issues 中（使用 `gh` CLI）
- **GitLab** — issues 位于仓库的 GitLab Issues 中（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **Local markdown** — issues 作为文件位于该仓库的 `.scratch/<feature>/` 下（适合 solo 项目或没有 remote 的仓库）
- **Other**（Jira、Linear 等）— 请用户用一段话描述工作流；skill 会将其记录为自由形式散文

**Section B — Triage label vocabulary.**

> 解释器：当 `triage` skill 处理传入 issue 时，它通过一个状态机移动它——需要评估、等待报告者、准备好供 AFK agent 接手、需要人类，或不会修复。为此，它需要应用匹配*你实际配置*的字符串的标签（或 issue tracker 中的等效物）。如果你的仓库已经使用不同的标签名称（例如 `bug:triage` 而非 `needs-triage`），在这里映射它们，这样 skill 就会应用正确的而非创建重复项。

五个规范角色：

- `needs-triage` — 维护者需要评估
- `needs-info` — 等待报告者
- `ready-for-agent` — 完全指定，AFK-ready（agent 可以在没有人类上下文的情况下接手）
- `ready-for-human` — 需要人类实现
- `wontfix` — 不会处理

默认：每个角色的字符串等于其名称。询问用户是否想要覆盖任何。如果他们的 issue tracker 没有现有标签，默认值就可以了。

**Section C — Domain docs.**

> 解释器：一些 skills（`improve-codebase-architecture`、`diagnose`、`tdd`）阅读 `CONTEXT.md` 文件来学习项目的领域语言，以及 `docs/adr/` 来了解过去的架构决策。它们需要知道仓库有一个全局上下文还是多个（例如，前后端分开的 monorepo），以便它们在正确的地方查找。

确认布局：

- **Single-context** — 仓库根目录下一个 `CONTEXT.md` + `docs/adr/`。大多数仓库是这样。
- **Multi-context** — 根目录一个 `CONTEXT-MAP.md` 指向每个上下文的 `CONTEXT.md` 文件（通常是 monorepo）。

### 3. Confirm and edit（确认并编辑）

向用户展示草稿：

- 要添加到正在编辑的 `CLAUDE.md` / `AGENTS.md` 中的 `## Agent skills` 块（参见步骤 4 的选择规则）
- `docs/agents/issue-tracker.md`、`docs/agents/triage-labels.md`、`docs/agents/domain.md` 的内容

让他们在写入之前编辑。

### 4. Write（写入）

**选择要编辑的文件：**

- 如果 `CLAUDE.md` 存在，编辑它。
- 否则如果 `AGENTS.md` 存在，编辑它。
- 如果两者都不存在，询问用户要创建哪一个——不要替他们选择。

当 `CLAUDE.md` 已经存在时（或反之亦然），永远不要创建 `AGENTS.md`——始终编辑已经存在的那一个。

如果所选文件中已存在 `## Agent skills` 块，就地更新其内容而非追加重复项。不要覆盖用户对周围部分的编辑。

该块：

```markdown
## Agent skills

### Issue tracker

[issue 追踪位置的单行摘要]. See `docs/agents/issue-tracker.md`.

### Triage labels

[标签词汇的单行摘要]. See `docs/agents/triage-labels.md`.

### Domain docs

[布局的单行摘要 — "single-context" 或 "multi-context"]. See `docs/agents/domain.md`.
```

然后使用本 skill 文件夹中的种子模板作为起点写入三个文档文件：

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md) — 本地 markdown issue tracker
- [triage-labels.md](./triage-labels.md) — 标签映射
- [domain.md](./domain.md) — 领域文档消费规则 + 布局

对于 "other" issue tracker，使用用户的描述从头开始写 `docs/agents/issue-tracker.md`。

### 5. Done（完成）

告诉用户设置已完成，哪些 engineering skills 现在会读取这些文件。提到他们以后可以直接编辑 `docs/agents/*.md`——仅当他们想切换 issue tracker 或从头重新开始时，才需要重新运行本 skill。
