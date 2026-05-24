---
name: obsidian-vault
description: 使用 wikilinks 和 index notes 在 Obsidian vault 中搜索、创建和管理笔记。当用户想在 Obsidian 中查找、创建或整理笔记时使用。
---

# Obsidian Vault

## Vault location（Vault 位置）

`/mnt/d/Obsidian Vault/AI Research/`

大部分在根级别保持扁平。

## Naming conventions（命名约定）

- **Index notes**：聚合相关主题（例如，`Ralph Wiggum Index.md`、`Skills Index.md`、`RAG Index.md`）
- 所有笔记名称使用 **Title case**
- 不用文件夹来组织 — 使用链接和 index notes 代替

## Linking（链接）

- 使用 Obsidian `[[wikilinks]]` 语法：`[[Note Title]]`
- 笔记在底部链接到依赖/相关笔记
- Index notes 只是 `[[wikilinks]]` 的列表

## Workflows（工作流）

### Search for notes（搜索笔记）

```bash
# 按文件名搜索
find "/mnt/d/Obsidian Vault/AI Research/" -name "*.md" | grep -i "keyword"

# 按内容搜索
grep -rl "keyword" "/mnt/d/Obsidian Vault/AI Research/" --include="*.md"
```

或直接使用 Grep/Glob 工具在 vault 路径上搜索。

### Create a new note（创建新笔记）

1. 文件名使用 **Title Case**
2. 将内容写成一个学习单元（按 vault 规则）
3. 在底部添加指向相关笔记的 `[[wikilinks]]`
4. 如果是编号序列的一部分，使用层级编号方案

### Find related notes（查找相关笔记）

在整个 vault 中搜索 `[[Note Title]]` 以找到 backlinks：

```bash
grep -rl "\\[\\[Note Title\\]\\]" "/mnt/d/Obsidian Vault/AI Research/"
```

### Find index notes（查找 index notes）

```bash
find "/mnt/d/Obsidian Vault/AI Research/" -name "*Index*"
```
