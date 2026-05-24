---
name: to-issues
description: 使用 tracer-bullet 垂直切片将计划、规范或 PRD 拆分为可在 issue 追踪器上独立获取的 issues。当用户想将计划转化为 issues、创建实现工单，或将工作拆分为 issues 时使用。
---

# To Issues（拆分为 Issues）

使用垂直切片（tracer bullets）将计划拆分为可独立获取的 issues。

issue 追踪器和分类标签词汇应该已经提供给你——如果没有，运行 `/setup-matt-pocock-skills`。

## Process（流程）

### 1. Gather context（收集上下文）

根据对话上下文中已有的内容进行工作。如果用户传递了一个 issue 引用（issue 编号、URL 或路径）作为参数，从 issue 追踪器获取它并阅读其完整正文和评论。

### 2. Explore the codebase（探索代码库）（可选）

如果你尚未探索代码库，请这样做以了解代码的当前状态。issue 标题和描述应使用项目的领域词汇表词汇，并尊重你正在修改区域的 ADR。

### 3. Draft vertical slices（起草垂直切片）

将计划拆分为 **tracer bullet** issues。每个 issue 是一个薄薄的垂直切片，贯穿所有集成层端到端，而不是某一层的水平切片。

切片可以是 'HITL' 或 'AFK'。HITL 切片需要人类交互，例如架构决策或设计审查。AFK 切片可以在无需人类交互的情况下实现和合并。在可能的情况下优先选择 AFK 而非 HITL。

<vertical-slice-rules>
- 每个切片交付一个狭窄但完整的贯穿每一层的路径（schema、API、UI、tests）
- 一个完成的切片可以独立演示或验证
- 偏好许多薄切片而非少数厚切片
</vertical-slice-rules>

### 4. Quiz the user（考问用户）

将提议的拆分作为编号列表展示。对于每个切片，展示：

- **Title（标题）**：简短的描述性名称
- **Type（类型）**：HITL / AFK
- **Blocked by（被阻塞于）**：哪些其他切片（如果有）必须先完成
- **User stories covered（覆盖的用户故事）**：这解决了哪些用户故事（如果源材料中有）

询问用户：

- 粒度感觉对吗？（太粗 / 太细）
- 依赖关系正确吗？
- 是否有切片应该合并或进一步拆分？
- 正确的切片是否被标记为 HITL 和 AFK？

迭代直到用户批准拆分。

### 5. Publish the issues to the issue tracker（发布 issues 到 issue 追踪器）

对于每个批准的切片，在 issue 追踪器上发布一个新 issue。使用下面的 issue 正文模板。这些 issues 被认为已准备好供 AFK agent 处理，因此除非另有指示，否则用正确的分类标签发布它们。

按依赖顺序发布 issues（先发布阻塞者），以便你可以在 "Blocked by" 字段中引用真实的 issue 标识符。

<issue-template>
## Parent（父 issue）

对 issue 追踪器上父 issue 的引用（如果源是现有 issue，否则省略此部分）。

## What to build（构建内容）

对这个垂直切片的简洁描述。描述端到端行为，而非逐层实现。

避免具体的文件路径或代码片段——它们很快会过时。例外：如果原型产生的片段能比散文更精确地编码一个决策（状态机、reducer、schema、类型形状），将其内联到这里，并简要注明它来自原型。修剪到决策丰富的部分——不是可工作的演示，只是关键部分。

## Acceptance criteria（验收标准）

- [ ] 标准 1
- [ ] 标准 2
- [ ] 标准 3

## Blocked by（被阻塞于）

- 对阻塞工单的引用（如果有）

或者 "None - can start immediately"（无——可立即开始）如果没有阻塞者。

</issue-template>

不要关闭或修改任何父 issue。
