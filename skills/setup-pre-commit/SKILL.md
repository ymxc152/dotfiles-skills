---
name: setup-pre-commit
description: 在当前仓库设置 Husky pre-commit hooks，包含 lint-staged（Prettier）、类型检查和测试。当用户想添加 pre-commit hooks、设置 Husky、配置 lint-staged，或添加 commit 时的格式化/类型检查/测试时使用。
---

# Setup Pre-Commit Hooks（设置 Pre-Commit Hooks）

## What This Sets Up（设置内容）

- **Husky** pre-commit hook
- **lint-staged** 对所有暂存文件运行 Prettier
- **Prettier** 配置（如果缺失）
- pre-commit hook 中的 **typecheck** 和 **test** 脚本

## Steps（步骤）

### 1. Detect package manager（检测包管理器）

检查 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。使用存在的那个。如果不确定，默认 npm。

### 2. Install dependencies（安装依赖）

作为 devDependencies 安装：

```
husky lint-staged prettier
```

### 3. Initialize Husky（初始化 Husky）

```bash
npx husky init
```

这会创建 `.husky/` 目录并在 package.json 中添加 `prepare: "husky"`。

### 4. Create `.husky/pre-commit`（创建 `.husky/pre-commit`）

写入此文件（Husky v9+ 不需要 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**适配**：将 `npm` 替换为检测到的包管理器。如果 package.json 中没有 `typecheck` 或 `test` 脚本，省略这些行并告知用户。

### 5. Create `.lintstagedrc`（创建 `.lintstagedrc`）

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. Create `.prettierrc` (if missing)（创建 `.prettierrc`）（如果缺失）

仅在不存在 Prettier 配置时创建。使用以下默认值：

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. Verify（验证）

- [ ] `.husky/pre-commit` 存在且可执行
- [ ] `.lintstagedrc` 存在
- [ ] package.json 中的 `prepare` 脚本是 `"husky"`
- [ ] `prettier` 配置存在
- [ ] 运行 `npx lint-staged` 验证它能工作

### 8. Commit（提交）

暂存所有更改/创建的文件并用消息提交：`Add pre-commit hooks (husky + lint-staged + prettier)`

这会通过新的 pre-commit hooks——一个很好的冒烟测试，验证一切正常。

## Notes（说明）

- Husky v9+ 不需要 hook 文件中的 shebang
- `prettier --ignore-unknown` 跳过 Prettier 无法解析的文件（图片等）
- pre-commit 先运行 lint-staged（快速，仅暂存文件），然后运行完整 typecheck 和 tests
