---
name: improve-codebase-architecture
description: 在代码库中寻找深化机会，参考 CONTEXT.md 中的领域语言和 docs/adr/ 中的决策。当用户想改进架构、寻找重构机会、整合紧耦合模块，或使代码库更具可测试性和 AI 可导航性时使用。
---

# Improve Codebase Architecture（改进代码库架构）

发现架构摩擦并提出**深化机会**——将 shallow modules（浅层模块）转变为 deep modules（深层模块）的重构。目标是可测试性和 AI 可导航性。

## Glossary（词汇表）

在每个建议中精确使用这些术语。一致的语言就是重点——不要 drift 到 "component"、"service"、"API" 或 "boundary"。完整定义见 [LANGUAGE.md](LANGUAGE.md)。

- **Module** — 任何带有接口和实现的东西（函数、类、包、slice）。
- **Interface** — 调用者使用模块必须知道的一切：类型、不变量、错误模式、顺序、配置。不仅仅是类型签名。
- **Implementation** — 内部的代码。
- **Depth** — 接口处的杠杆：小接口后面的大量行为。**Deep** = 高杠杆。**Shallow** = 接口几乎和实现一样复杂。
- **Seam** — 接口所在的位置；行为可以在不就地编辑的情况下改变的地方。（使用这个，而非 "boundary"。）
- **Adapter** — 在 seam 处满足接口的具体事物。
- **Leverage** — 调用者从 depth 中获得的东西。
- **Locality** — 维护者从 depth 中获得的东西：变更、Bug、知识集中在一处。

关键原则（完整列表见 [LANGUAGE.md](LANGUAGE.md)）：

- **Deletion test**：想象删除这个模块。如果复杂性消失了，它就是个 pass-through。如果复杂性在 N 个调用者中重新出现，它就是在发挥作用。
- **The interface is the test surface.**
- **One adapter = hypothetical seam. Two adapters = real seam.**

本 skill 由项目的领域模型*提供信息*。领域语言为好的 seams 命名；ADR 记录本 skill 不应重新争论的决策。

## Process（流程）

### 1. Explore（探索）

首先阅读项目的领域词汇表和你正在修改区域的任何 ADR。

然后使用 Agent 工具并设置 `subagent_type=Explore` 来遍历代码库。不要遵循僵化的启发式方法——有机地探索并注意你遇到摩擦的地方：

- 理解一个概念需要在许多小模块之间来回跳转的地方？
- 模块是**shallow**的地方——接口几乎和实现一样复杂？
- 纯函数被提取出来只是为了可测试性，但真正的 Bug 隐藏在被调用的方式中（没有 **locality**）？
- 紧耦合模块泄漏到它们的 seams 之外的地方？
- 代码库的哪些部分未经测试，或难以通过当前接口测试？

对你怀疑是 shallow 的任何东西应用 **deletion test**：删除它会集中复杂性，还是只是移动它？"是的，会集中"就是你要的信号。

### 2. Present candidates（展示候选）

展示一个编号的深化机会列表。对于每个候选：

- **Files** — 涉及哪些文件/模块
- **Problem** — 当前架构为什么造成摩擦
- **Solution** — 将要改变的内容的纯英文描述
- **Benefits** — 用 locality 和 leverage 解释，以及测试会如何改进

**对领域使用 CONTEXT.md 词汇，对架构使用 [LANGUAGE.md](LANGUAGE.md) 词汇。** 如果 `CONTEXT.md` 定义了 "Order"，谈论 "the Order intake module"——而非 "the FooBarHandler"，也非 "the Order service"。

**ADR 冲突**：如果候选与现有 ADR 矛盾，仅在摩擦足够大以至于值得重新审视 ADR 时才展示它。清楚标记（例如 *"contradicts ADR-0007 — but worth reopening because…"*）。不要列出 ADR 禁止的每一个理论重构。

不要提议接口。问用户："你想探索哪一个？"

### 3. Grilling loop（追问循环）

一旦用户选择了一个候选，就进入 grilling 对话。与他们一起沿着设计树走——约束、依赖、深化模块的形状、什么位于 seam 后面、什么测试能存活。

决策固化时的副作用内联发生：

- **以 CONTEXT.md 中不存在的概念命名深化模块？** 将术语添加到 `CONTEXT.md`——与 `/grill-with-docs` 相同的纪律（参见 [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md)）。如果不存在，惰性地创建文件。
- **在对话中 sharpen 模糊术语？** 立即更新 `CONTEXT.md`。
- **用户以负载理由拒绝候选？** 提议一个 ADR，框架为：*"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"* 仅当未来的探索者确实需要这个原因来避免重新建议相同的事情时才提议——跳过短暂的原因（"not worth it right now"）和自明的原因。参见 [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md)。
- **想为深化模块探索替代接口？** 参见 [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md)。
