---
name: grill-with-docs
description: 针对现有领域模型挑战你的计划的 grilling 会话，sharpen 术语，并在决策固化时内联更新文档（CONTEXT.md、ADR）。当用户想针对其项目语言和已记录决策对计划进行压力测试时使用。
---

<what-to-do>

就这个计划的每个方面无情地面试我，直到我们达成共同理解。沿着设计树的每个分支向下走，逐个解决决策之间的依赖关系。对于每个问题，提供你的推荐答案。

一次问一个问题，在继续之前等待每个问题的反馈。

如果一个问题可以通过探索代码库来回答，那就探索代码库代替。

</what-to-do>

<supporting-info>

## Domain awareness（领域意识）

在代码库探索期间，同时查找现有文档：

### File structure（文件结构）

大多数仓库只有一个上下文：

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

如果根目录存在 `CONTEXT-MAP.md`，则该仓库有多个上下文。地图指向每个上下文所在的位置：

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← 系统范围的决策
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← 上下文特定的决策
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

惰性地创建文件——只有当你有内容可写时才创建。如果不存在 `CONTEXT.md`，在第一个术语被解决时创建一个。如果不存在 `docs/adr/`，在第一个 ADR 需要时创建它。

## During the session（会话期间）

### Challenge against the glossary（针对词汇表挑战）

当用户使用的术语与 `CONTEXT.md` 中的现有语言冲突时，立即指出。"你的词汇表将 'cancellation' 定义为 X，但你似乎指的是 Y——到底是哪个？"

### Sharpen fuzzy language（sharpen 模糊语言）

当用户使用模糊或 overloaded 的术语时，提议一个精确的规范术语。"你说的是 'account'——你指的是 Customer 还是 User？它们是不同的东西。"

### Discuss concrete scenarios（讨论具体场景）

当讨论领域关系时，用具体场景对它们进行压力测试。发明探测边界情况并迫使用户精确概念之间边界的场景。

### Cross-reference with code（与代码交叉验证）

当用户陈述某事如何工作时，检查代码是否同意。如果你发现矛盾，提出来："你的代码取消整个 Orders，但你刚刚说 partial cancellation 是可能的——哪个是对的？"

### Update CONTEXT.md inline（内联更新 CONTEXT.md）

当一个术语被解决时，立即更新 `CONTEXT.md`。不要批量处理——在发生时捕获它们。使用 [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) 中的格式。

`CONTEXT.md` 应该完全不含实现细节。不要将 `CONTEXT.md` 当作规范、草稿纸或实现决策的仓库。它是一个词汇表，仅此而已。

### Offer ADRs sparingly（谨慎提供 ADR）

仅在以下三点都为真时才提议创建 ADR：

1. **难以逆转** — 改变主意的代价是有意义的
2. **没有上下文会让人惊讶** — 未来的读者会想知道"为什么他们这样做？"
3. **真实权衡的结果** — 存在真正的替代方案，你出于特定原因选择了其中一个

如果缺少任何一点，跳过 ADR。使用 [ADR-FORMAT.md](./ADR-FORMAT.md) 中的格式。

</supporting-info>
