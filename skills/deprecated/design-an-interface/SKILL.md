---
name: design-an-interface
description: 使用并行 sub-agents 为模块生成多种截然不同的接口设计。当用户想设计 API、探索接口选项、比较模块形状，或提到 "design it twice" 时使用。
---

# Design an Interface（设计接口）

基于 "A Philosophy of Software Design" 中的 "Design It Twice"：你的第一个想法不太可能最好。生成多种截然不同的设计，然后比较。

## Workflow（工作流）

### 1. Gather Requirements（收集需求）

在设计之前，了解：

- [ ] 这个模块解决什么问题？
- [ ] 调用者是谁？（其他模块、外部用户、测试）
- [ ] 关键操作是什么？
- [ ] 有什么约束？（性能、兼容性、现有模式）
- [ ] 什么应该隐藏在里面，什么应该暴露？

问："这个模块需要做什么？谁会使用它？"

### 2. Generate Designs (Parallel Sub-Agents)（生成设计）（并行 Sub-Agents）

使用 Task tool 同时生成 3+ 个 sub-agents。每个必须产生一种**截然不同的**方法。

```
每个 sub-agent 的 prompt 模板：

为以下模块设计接口：[module description]

需求：[gathered requirements]

每个 agent 的约束：[给每个 agent 分配不同的约束]
- Agent 1: "最小化方法数 — 最多 1-3 个方法"
- Agent 2: "最大化灵活性 — 支持多种用例"
- Agent 3: "为最常见场景优化"
- Agent 4: "从 [特定范式/库] 汲取灵感"

输出格式：
1. 接口签名（类型/方法）
2. 使用示例（调用者实际如何使用它）
3. 这个设计在内部隐藏了什么
4. 这种方法的权衡
```

### 3. Present Designs（展示设计）

每个设计展示：

1. **Interface signature** — 类型、方法、参数
2. **Usage examples** — 调用者在实践中实际如何使用它
3. **What it hides** — 保持在内部的复杂性

依次展示设计，以便用户在比较之前能吸收每种方法。

### 4. Compare Designs（比较设计）

展示所有设计后，在以下方面比较它们：

- **Interface simplicity**：方法越少，参数越简单
- **General-purpose vs specialized**：灵活性 vs 专注
- **Implementation efficiency**：形状是否允许高效的内部实现？
- **Depth**：小接口隐藏显著复杂性（好）vs 大接口配薄实现（坏）
- **Ease of correct use** vs **ease of misuse**

用散文讨论权衡，不要用表格。突出设计分歧最大的地方。

### 5. Synthesize（综合）

通常最好的设计结合了多种选项的见解。问：

- "哪种设计最符合你的主要用例？"
- "其他设计中有什么元素值得纳入？"

## Evaluation Criteria（评估标准）

来自 "A Philosophy of Software Design"：

**Interface simplicity**：方法越少，参数越简单 = 越容易学习和正确使用。

**General-purpose**：能处理未来的用例而无需更改。但谨防过度泛化。

**Implementation efficiency**：接口形状是否允许高效实现？还是迫使内部实现变得笨拙？

**Depth**：小接口隐藏显著复杂性 = deep module（好）。大接口配薄实现 = shallow module（避免）。

## Anti-Patterns（反模式）

- 不要让 sub-agents 产生相似的设计——强制要求截然不同
- 不要跳过比较——价值在于对比
- 不要实现——这纯粹是关于接口形状
- 不要基于实现工作量来评估
