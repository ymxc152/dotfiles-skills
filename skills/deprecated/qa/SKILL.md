---
name: qa
description: 交互式 QA 会话，用户以对话方式报告 Bug 或 issue，agent 提交 GitHub issues。在后台探索代码库以获取上下文和领域语言。当用户想报告 Bug、做 QA、以对话方式提交 issues，或提到 "QA session" 时使用。
---

# QA Session（QA 会话）

运行一个交互式 QA 会话。用户描述他们遇到的问题。你澄清、探索代码库获取上下文，并提交持久、以用户为中心、使用项目领域语言的 GitHub issues。

## For each issue the user raises（对于用户提出的每个 issue）

### 1. Listen and lightly clarify（倾听并轻微澄清）

让用户用他们自己的话描述问题。问**最多 2-3 个简短的澄清问题**，聚焦在：

- 他们期望的 vs 实际发生的
- 复现步骤（如果不明显）
- 是一致的还是间歇性的

不要过度面试。如果描述足够清晰可以提交，就继续前进。

### 2. Explore the codebase in the background（在后台探索代码库）

在与用户交谈的同时，在后台启动一个 Agent（subagent_type=Explore）来理解相关区域。目标**不是**找到修复——而是：

- 了解该区域使用的领域语言（检查 UBIQUITOUS_LANGUAGE.md）
- 理解该功能应该做什么
- 识别用户面向的行为边界

这个上下文帮助你写一个更好的 issue——但 issue 本身**不应该**引用具体文件、行号或内部实现细节。

### 3. Assess scope: single issue or breakdown?（评估范围：单个 issue 还是拆分？）

在提交之前，决定这是**单个 issue** 还是需要**拆分为多个 issues**。

在以下情况拆分：

- 修复跨越多个独立区域（例如"表单验证错误 AND 成功消息缺失 AND 重定向损坏"）
- 存在明显可分离的关切，不同的人可以并行处理
- 用户描述的东西有多个不同的失败模式或症状

在以下情况保持为单个 issue：

- 是一个地方的一个行为错了
- 症状都是由同一个根行为引起的

### 4. File the GitHub issue(s)（提交 GitHub issue(s)）

用 `gh issue create` 创建 issues。不要先问用户审查——直接提交并分享 URL。

Issues 必须是**持久的**——即使在重大重构后它们仍然应该有意义。从用户的视角写。

#### For a single issue（单个 issue）

使用此模板：

```
## What happened（发生了什么）

[用平实语言描述用户经历的实际行为]

## What I expected（我期望的）

[描述期望的行为]

## Steps to reproduce（复现步骤）

1. [开发者可以遵循的具体编号步骤]
2. [使用代码库的领域术语，而非内部模块名称]
3. [包含相关输入、标志或配置]

## Additional context（额外上下文）

[来自用户或代码库探索的任何额外观察，帮助框定 issue — 例如"这只在使用 Docker layer 时发生，而非 filesystem layer" — 使用领域语言但不引用文件]
```

#### For a breakdown (multiple issues)（拆分）（多个 issues）

按依赖顺序创建 issues（先阻塞者），以便你可以在 "Blocked by" 中引用真实的 issue 编号。

每个子 issue 使用此模板：

```
## Parent issue（父 issue）

#<parent-issue-number>（如果你创建了跟踪 issue）或 "Reported during QA session"

## What's wrong（什么问题）

[描述这个具体的行为问题——只是这个切片，而非整个报告]

## What I expected（我期望的）

[这个具体切片的期望行为]

## Steps to reproduce（复现步骤）

1. [针对 THIS issue 的步骤]

## Blocked by（被阻塞于）

- #<issue-number>（如果这个 issue 不能修复直到另一个解决）

或 "None — can start immediately" 如果没有阻塞者。

## Additional context（额外上下文）

[与此切片相关的任何额外观察]
```

创建拆分时：

- **偏好许多薄 issues 而非少数厚 issues** — 每个都应该可独立修复和验证
- **诚实标记阻塞关系** — 如果 issue B 确实不能在 issue A 修复之前测试，说出来。如果它们是独立的，两者都标记为 "None — can start immediately"
- **按依赖顺序创建 issues**，以便你可以在 "Blocked by" 中引用真实的 issue 编号
- **最大化并行性** — 目标是多个人（或 agents）可以同时抓取不同的 issues

#### Rules for all issue bodies（所有 issue 正文的规则）

- **没有文件路径或行号** — 这些会过时
- **使用项目的领域语言**（如果存在，检查 UBIQUITOUS_LANGUAGE.md）
- **描述行为，而非代码** — "sync service 未能应用 patch" 而非 "applyPatch() 在第 42 行抛出"
- **复现步骤是强制的** — 如果你无法确定，问用户
- **保持简洁** — 开发者应该能在 30 秒内读完 issue

提交后，打印所有 issue URL（并总结阻塞关系）并问："Next issue, or are we done?"

### 5. Continue the session（继续会话）

继续直到用户说完成。每个 issue 是独立的——不要批量处理。
