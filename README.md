# dotfiles-skills

个人 AI 编码技能库（Kimi / Claude Code / 其他 Agent 兼容）。跨设备同步，一键安装。

## 技能来源

| 上游仓库 | 技能数 | 说明 |
|---------|--------|------|
| [mattpocock/skills](https://github.com/mattpocock/skills) | 28 | 工程、生产力、写作 |
| [karpathy/skills](https://github.com/karpathy/skills) | 1 | 编程行为准则 |
| [anthropics/skills](https://github.com/anthropics/skills) | 5 | 前端设计、MCP、测试、PDF |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | 5 | 前端、性能、安全、代码审查、上下文工程 |
| [trailofbits/skills](https://github.com/trailofbits/skills) | 3 | 安全审计、Semgrep、变体分析 |
| [garrytan/gstack](https://github.com/garrytan/gstack) | ~3 | Office Hours、Review、QA |
| [NeoLabHQ/context-engineering-kit](https://github.com/NeoLabHQ/context-engineering-kit) | 1 | 简洁写作 |

**总计：41 个技能**，描述和主体已翻译为中文，英文专有名词保留（TDD、PRD、ADR、HITL、AFK、Playwright、Semgrep、CodeQL 等）。

## 目录结构

```
skills/
├── caveman
├── code-review-and-quality
├── context-engineering
├── design-an-interface
├── diagnose
├── edit-article
├── frontend-design
├── frontend-ui-engineering
├── git-guardrails-claude-code
├── grill-me
├── grill-with-docs
├── handoff
├── improve-codebase-architecture
├── karpathy-guidelines
├── mcp-builder
├── migrate-to-shoehorn
├── obsidian-vault
├── pdf
├── performance-optimization
├── prototype
├── qa
├── request-refactor-plan
├── review
├── scaffold-exercises
├── security-and-hardening
├── setup-matt-pocock-skills
├── setup-pre-commit
├── sharp-edges
├── tdd
├── to-issues
├── to-prd
├── triage
├── ubiquitous-language
├── variant-analysis
├── webapp-testing
├── write-a-skill
├── write-concisely
├── writing-beats
├── writing-fragments
├── writing-shape
└── zoom-out
```

## 快速开始

### 首次安装（新机器）

```bash
git clone https://github.com/<your-username>/dotfiles-skills.git ~/dotfiles-skills
cd ~/dotfiles-skills
./install.sh
```

`install.sh` 会自动：
1. 备份现有的 `~/.claude/skills/` 到 `~/.claude/skills-backup-YYYYMMDD-HHMMSS/`
2. 用 `rsync` 将仓库中的技能复制到 `~/.claude/skills/`

### 编辑后反向同步

如果你在 Kimi/Claude 会话中修改了本地技能文件，想把改动提交到仓库：

```bash
cd ~/dotfiles-skills
./update.sh   # 预览 + 确认后反向同步
```

然后常规提交：

```bash
git add -A
git commit -m "feat: update security-and-hardening skill"
git push
```

## 跨设备同步流程

```
Machine A (编辑技能)
  → ~/.claude/skills/ 本地修改
  → ./update.sh 同步回仓库
  → git commit && git push

Machine B (拉取更新)
  → git pull
  → ./install.sh
  → ~/.claude/skills/ 自动更新
```

## 添加新技能

1. 在 `skills/` 下创建新目录，放入 `SKILL.md`
2. 运行 `./update.sh` 或直接复制到 `~/.claude/skills/` 测试
3. 提交并推送

### SKILL.md 格式

```yaml
---
name: my-skill
description: 技能描述。在 [触发条件] 时使用。
---

# 技能标题

## Overview（概述）

...
```

## 与 `npx skills@latest add` 的关系

`npx skills@latest add <repo>` 适合**首次安装**上游技能。本仓库用于：

- **版本控制**：锁定你认可的技能版本
- **中文翻译**：保留自己的本地化修改
- **自定义技能**：添加上游没有的私有技能
- **跨设备同步**：一行命令重建整个环境

## 兼容性

| 工具 | 扫描路径 |
|------|---------|
| Kimi CLI | `~/.kimi/skills/`、`~/.config/agents/skills/` |
| Claude Code | `~/.claude/skills/`（推荐） |

本仓库默认安装到 `~/.claude/skills/`。
