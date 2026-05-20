---
name: writing-fragments
description: 对用户进行 mining（挖掘）以获取 fragments（碎片）——异质的写作 nuggets（金块）（claims、vignettes、sharp sentences、half-thoughts）——并将它们追加到单个文档中作为未来文章的原始材料。当用户想在施加结构之前发展想法，或提到 "fragments"、"ideate" 或写作的 "raw material" 时使用。
---

<what-to-do>

运行一个产生 fragments 的 grilling 会话。就用户想写的任何东西无情地面试他们。不要强加阶段、大纲或结构——这明确超出范围。

当 fragments 从对话的任何一方出现时，将它们追加到单个 markdown 文件。用户将在会话期间编辑这个文件；总是在写入前重新阅读它以便保留他们的编辑。

如果用户没有传递路径，问一次在哪里保存文档，然后在会话的其余部分记住它。

从用户说的第一句话开始捕获 fragments，包括初始提示。

第一次写入时，在顶部放一个单独的 H1，带一个 working title（以后可以更改），其他什么都没有——没有元数据、没有目录、没有日期。

</what-to-do>

<supporting-info>

## What is a fragment（什么是 fragment）

一个 fragment 是任何可能存活到最终文章中的文本片段。它必须对*作者可读*——作者能知道它是什么意思——但它不需要定义其术语或对 cold reader 可理解。门槛是"这是好写作的一部分吗？"，而非"这是一个自包含的论证吗？"

Fragments 是故意异质的。可以是 fragment 的示例：

- 一个你想在某个地方部署但还不知道在哪里的 sharp sentence。
- 一个带单行 justification 的 claim。
- 一个 vignette：发生的事、代码片段、场景、类比。
- 一个 half-thought："something about how X feels like Y, work this out later."
- 一个 quote、一段对话、一句 overheard 的话。
- 一个由感觉凝聚在一起的相关观察列表。
- 一个 complaint、一个 confession、一个 punchline。

小说家的日记就是模型：多年无结构的 noticings，后来被挖掘为原始材料。Fragments 就是 noticings。

## File format（文件格式）

```markdown
# Working title

第一个 fragment 在这里。

它可以是多段。它可以包含列表、代码、quotes——无论
fragment  naturally 是什么形状。

---

第二个 fragment。

---

> 用户想保留的 quoted line。

对它的反应。

---

- 一组相关观察
- 由感觉凝聚在一起
- 想彼此靠近
```

Fragments 由水平线（`\n---\n`）分隔。正文中没有标题。没有标签。没有超出添加顺序的顺序。

## Writing rhythm（写作节奏）

静默追加。不要为每个 fragment 请求许可。顺便提及你添加了什么（"adding that"），但不要打断对话用保存对话框。

每次写入前：从磁盘重新阅读文件。用户可能在回合之间编辑、重新排序或删除 fragments——保留他们的更改。永远不要覆盖文件；只追加（或者，如果用户要求，就地编辑特定 fragment）。

用户可以随时说 "cut the last one"、"rewrite that one sharper"、"merge those two"。将这些视为一等指令。

</supporting-info>
