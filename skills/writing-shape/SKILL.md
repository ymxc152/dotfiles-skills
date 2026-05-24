---
name: writing-shape
description: 获取一个原始材料的 markdown 文件，通过对话会话将其塑造成文章——起草候选开头、逐段扩展文章、在每一步争论格式（列表、表格、callouts、quotes）。当用户有一堆笔记、fragments 或粗略草稿，并想帮助将其变成可发布的东西时使用。
---

<what-to-do>

用户传递了（或将传递）一个原始材料的 markdown 文件。将其视为输入堆——从整齐的 fragment 列表到无结构的 prose 墙到 transcript。格式不重要。在做其他事情之前先从头到尾阅读它。

然后运行一个产生单独文章文档的 shaping 会话。不要编辑原始材料文件——对本 skill 它是只读的。

如果用户没有说在哪里保存文章，问一次并记住路径。用户将在会话期间编辑文章文件；总是在写入前重新阅读它以便保留他们的编辑。

</what-to-do>

<supporting-info>

## The loop（循环）

1. **Read the pile（阅读材料堆）。** 完整阅读输入文件。对其内容形成感觉。
2. **Draft 2–3 candidate openings（起草 2–3 个候选开头）。** 每个开头应该暗示文章的不同 thesis 或角度。展示所有开头。迫使用户选择或组合一个 hybrid。被选中的开头定义了文章的其余部分必须做什么。
3. **Grow paragraph by paragraph（逐段扩展）。** 开头确定后，问 "given this opening, what does the reader need to hear next?" 从材料堆中拉取材料来回答。争论下一个 beat 应该是段落、列表、表格、callout、quote、代码块。每个格式选择应该是有意且可辩护的。
4. **Append to the article file as you go（边写边追加到文章文件）。** 不要批量处理。每个商定的段落或块立即写入，以便用户能看到文章成形。
5. **Loop step 3 until the article is done（循环步骤 3 直到文章完成）。** 用户决定何时完成。

## Conversational feel（对话感）

这是一个倒置的 grilling 会话。在构思中，问题是 "what are you actually noticing?" 这里是 "what is this article actually arguing, and in what order does the reader need to hear it?" 推回去。拒绝让 weak transitions 滑过。如果一个段落不配它的位置，剪掉它。

要持续使用的具体动作：

- "What does this paragraph do for the reader that the previous one didn't?"
- "If I cut this, what breaks?"
- "Is this prose, or should it be a list? Why prose?"
- "This sentence is doing two jobs — split it or pick one."
- "The opening promised X. We've drifted to Y. Either re-thread it or change the opening."

## Pulling from the pile（从材料堆中拉取）

将原始材料视为采石场，而非脚本。拉取一个 fragment， rework 它以适应周围段落，然后放置它。一个 fragment 可以拆分到多个段落中，与另一个合并，或改述。材料堆的工作是被挖掘；文章的工作是读起来像同一个声音。

如果材料堆缺少文章需要的东西，显式命名缺口："We need an example here and the pile doesn't have one — give me one now or we cut this section."

## Format arguments to actually have（实际要进行的格式争论）

在选择如何渲染一个 beat 时，大声与用户权衡这些 tradeoffs，而非默默决定：

- **Prose vs. list（散文 vs 列表）。** 散文承载论证；列表承载并行项目。如果项目不是真正并行的，散文更好。如果是，列表扫描更快。
- **Inline vs. callout（内联 vs callout）。** Tips、warnings 和 asides 放在 callouts（`> [!TIP]`、`> [!NOTE]`）中——但前提是它们内联真的会打断主要论证。否则保持内联。
- **Table vs. repeated structure（表格 vs 重复结构）。** 如果相同形状重复 3+ 次且字段相同，用表格。否则用带粗体引语的散文。
- **Quote vs. paraphrase（引用 vs 改述）。** 当原始措辞就是重点时引用。当只有想法重要时改述。
- **Code block vs. inline code（代码块 vs 内联代码）。** 多行、可运行或说明性的 → 块。单个 token 或标识符 → 内联。

## Writing rhythm（写作节奏）

每个块商定后追加到文章文件。每次写入前从磁盘重新阅读文件——用户可能在回合之间编辑。永远不要盲目覆盖。如果用户想重写一个段落，就地编辑那个特定段落；其余不动。

## Out of scope（范围之外）

- 挖掘材料堆中没有的新 fragments（材料堆是输入——如果它不完整，命名缺口并要么让用户填充要么剪掉 section）。
- 编辑原始材料文件。
- 发布、为特定平台格式化，或添加用户未要求的前言。

</supporting-info>
