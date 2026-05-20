---
name: write-a-skill
description: 使用正确的结构、渐进式披露和捆绑资源创建新的 agent skills。当用户想创建、编写或构建新 skill 时使用。
---

# Writing Skills（编写 Skills）

## Process（流程）

1. **Gather requirements（收集需求）** — 询问用户：
   - 这个 skill 涵盖什么任务/领域？
   - 它应该处理哪些具体用例？
   - 它是否需要可执行脚本，还是只需要指令？
   - 是否包含任何参考材料？

2. **Draft the skill（起草 skill）** — 创建：
   - 带简洁指令的 SKILL.md
   - 如果内容超过 500 行，则创建额外的参考文件
   - 如果需要确定性操作，则创建实用脚本

3. **Review with user（与用户审查）** — 展示草稿并询问：
   - 这涵盖了你的用例吗？
   - 有什么缺失或不清楚的吗？
   - 任何部分应该更详细或更简洁吗？

## Skill Structure（Skill 结构）

```
skill-name/
├── SKILL.md           # 主要指令（必需）
├── REFERENCE.md       # 详细文档（如需要）
├── EXAMPLES.md        # 使用示例（如需要）
└── scripts/           # 实用脚本（如需要）
    └── helper.js
```

## SKILL.md Template（SKILL.md 模板）

```md
---
name: skill-name
description: 能力的简要描述。当 [具体触发条件] 时使用。
---

# Skill Name

## Quick start（快速开始）

[最小工作示例]

## Workflows（工作流）

[复杂任务的带检查清单的分步流程]

## Advanced features（高级功能）

[链接到单独文件：See [REFERENCE.md](REFERENCE.md)]
```

## Description Requirements（描述要求）

description 是你的 agent 决定加载哪个 skill 时**唯一能看到的东西**。它与其他所有已安装 skills 一起显示在 system prompt 中。你的 agent 阅读这些描述并根据用户的请求选择相关的 skill。

**目标**：给你的 agent 刚好足够的信息让它知道：

1. 这个 skill 提供什么能力
2. 何时/为什么触发它（特定关键词、上下文、文件类型）

**格式**：

- 最多 1024 个字符
- 用第三人称写
- 第一句：它做什么
- 第二句："Use when [具体触发条件]"

**好示例**：

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**坏示例**：

```
Helps with documents.
```

坏示例让你的 agent 无法将这个 skill 与其他文档 skill 区分开。

## When to Add Scripts（何时添加脚本）

在以下情况添加实用脚本：

- 操作是确定性的（验证、格式化）
- 相同的代码会被反复生成
- 错误需要显式处理

脚本节省 token 并提高可靠性，优于生成代码。

## When to Split Files（何时拆分文件）

在以下情况拆分为单独文件：

- SKILL.md 超过 100 行
- 内容有独立的领域（财务 vs 销售 schema）
- 高级功能很少需要

## Review Checklist（审查检查清单）

起草后，验证：

- [ ] 描述包含触发条件（"Use when..."）
- [ ] SKILL.md 在 100 行以下
- [ ] 没有时间敏感信息
- [ ] 术语一致
- [ ] 包含具体示例
- [ ] 引用仅深一层
