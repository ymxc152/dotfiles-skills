---
name: handoff
description: 将当前对话压缩成一份 handoff 文档，供另一个 agent 接手。
argument-hint: "What will the next session be used for?"
---

写一份 handoff 文档总结当前对话，以便一个新的 agent 可以继续工作。保存到用户操作系统的临时目录——而非当前工作区。

在文档中包含一个 "suggested skills" 部分，推荐 agent 应该调用的 skills。

不要复制已在其他产物中捕获的内容（PRD、计划、ADR、issues、commits、diffs）。通过路径或 URL 引用它们。

编辑掉任何敏感信息，例如 API keys、密码或个人身份信息。

如果用户传递了参数，将它们视为对下一次会话重点的描述，并相应地调整文档。
