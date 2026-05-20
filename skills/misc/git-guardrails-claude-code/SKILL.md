---
name: git-guardrails-claude-code
description: 设置 Claude Code hooks 来在 Claude 执行之前拦截危险的 git 命令（push、reset --hard、clean、branch -D 等）。当用户想防止破坏性 git 操作、添加 git 安全 hooks，或阻止 git push/reset 在 Claude Code 中执行时使用。
---

# Setup Git Guardrails（设置 Git 护栏）

设置一个 PreToolUse hook，在 Claude 执行之前拦截并阻止危险的 git 命令。

## What Gets Blocked（阻止内容）

- `git push`（所有变体包括 `--force`）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

被阻止时，Claude 会看到一条消息，告诉它无权访问这些命令。

## Steps（步骤）

### 1. Ask scope（询问范围）

询问用户：仅为此项目安装（`.claude/settings.json`）还是为所有项目安装（`~/.claude/settings.json`）？

### 2. Copy the hook script（复制 hook 脚本）

捆绑脚本位于：[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

根据范围复制到目标位置：

- **Project（项目）**：`.claude/hooks/block-dangerous-git.sh`
- **Global（全局）**：`~/.claude/hooks/block-dangerous-git.sh`

用 `chmod +x` 使其可执行。

### 3. Add hook to settings（将 hook 添加到设置）

添加到适当的设置文件：

**Project**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

如果设置文件已存在，将 hook 合并到现有的 `hooks.PreToolUse` 数组中——不要覆盖其他设置。

### 4. Ask about customization（询问定制）

询问用户是否想从阻止列表中添加或删除任何模式。相应地编辑复制的脚本。

### 5. Verify（验证）

快速测试：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

应该以退出码 2 退出并向 stderr 打印 BLOCKED 消息。
