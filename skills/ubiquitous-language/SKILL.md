---
name: ubiquitous-language
description: 从当前对话中提取 DDD 风格的 ubiquitous language（通用语言）词汇表，标记歧义并提议规范术语。保存到 UBIQUITOUS_LANGUAGE.md。当用户想定义领域术语、构建词汇表、harden 术语、创建 ubiquitous language，或提到 "domain model" 或 "DDD" 时使用。
disable-model-invocation: true
---

# Ubiquitous Language（通用语言）

从当前对话中提取并形式化领域术语，保存为一致的词汇表到本地文件。

## Process（流程）

1. **Scan the conversation（扫描对话）** 寻找与领域相关的名词、动词和概念
2. **Identify problems（识别问题）**：
   - 同一个词用于不同概念（歧义）
   - 不同词用于同一个概念（同义词）
   - 模糊或 overloaded 的术语
3. **Propose a canonical glossary（提议规范词汇表）** 带有主见性的术语选择
4. **Write to `UBIQUITOUS_LANGUAGE.md`** 在工作目录中使用以下格式
5. **Output a summary（输出摘要）** 在对话中内联

## Output Format（输出格式）

用以下结构写一个 `UBIQUITOUS_LANGUAGE.md` 文件：

```md
# Ubiquitous Language

## Order lifecycle

| Term        | Definition                                              | Aliases to avoid      |
| ----------- | ------------------------------------------------------- | --------------------- |
| **Order**   | A customer's request to purchase one or more items      | Purchase, transaction |
| **Invoice** | A request for payment sent to a customer after delivery | Bill, payment request |

## People

| Term         | Definition                                  | Aliases to avoid       |
| ------------ | ------------------------------------------- | ---------------------- |
| **Customer** | A person or organization that places orders | Client, buyer, account |
| **User**     | An authentication identity in the system    | Login, account         |

## Relationships

- An **Invoice** belongs to exactly one **Customer**
- An **Order** produces one or more **Invoices**

## Example dialogue

> **Dev:** "When a **Customer** places an **Order**, do we create the **Invoice** immediately?"
> **Domain expert:** "No — an **Invoice** is only generated once a **Fulfillment** is confirmed. A single **Order** can produce multiple **Invoices** if items ship in separate **Shipments**."
> **Dev:** "So if a **Shipment** is cancelled before dispatch, no **Invoice** exists for it?"
> **Domain expert:** "Exactly. The **Invoice** lifecycle is tied to the **Fulfillment**, not the **Order**."

## Flagged ambiguities

- "account" was used to mean both **Customer** and **User** — these are distinct concepts: a **Customer** places orders, while a **User** is an authentication identity that may or may not represent a **Customer**.
```

## Rules（规则）

- **要有主见。** 当同一个概念存在多个词时，选择最好的一个，将其他列为应避免的别名。
- **显式标记冲突。** 如果一个术语在对话中被歧义使用，在 "Flagged ambiguities" 部分指出并给出明确推荐。
- **只包含对领域专家相关的术语。** 跳过模块或类的名称，除非它们在领域语言中有意义。
- **保持定义简洁。** 最多一句。定义它是什么，而非它做什么。
- **展示关系。** 使用粗体术语名称，在明显的地方表达基数。
- **只包含领域术语。** 跳过通用编程概念（array、function、endpoint），除非它们有领域特定含义。
- **当自然集群出现时，将术语分组到多个表格中**（例如按子域、生命周期或参与者）。每个组有自己的标题和表格。如果所有术语属于单一内聚领域，一个表格即可——不要强行分组。
- **写一个示例对话。** 一个简短的对话（3-5 轮交换）between a dev 和 a domain expert，展示术语如何自然交互。对话应该澄清相关概念之间的边界，并展示术语被精确使用。

<example>

## Example dialogue

> **Dev:** "How do I test the **sync service** without Docker?"

> **Domain expert:** "Provide the **filesystem layer** instead of the **Docker layer**. It implements the same **Sandbox service** interface but uses a local directory as the **sandbox**."

> **Dev:** "So **sync-in** still creates a **bundle** and unpacks it?"

> **Domain expert:** "Exactly. The **sync service** doesn't know which layer it's talking to. It calls `exec` and `copyIn` — the **filesystem layer** just runs those as local shell commands."

</example>

## Re-running（重新运行）

在同一会话中再次调用时：

1. 阅读现有的 `UBIQUITOUS_LANGUAGE.md`
2. 纳入后续讨论中的任何新术语
3. 如果理解有所发展，更新定义
4. 重新标记任何新歧义
5. 重写示例对话以纳入新术语
