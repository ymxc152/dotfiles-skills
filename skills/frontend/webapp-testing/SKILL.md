---
name: webapp-testing
description: 使用 Playwright 与本地 web 应用交互并测试的工具包。支持验证前端功能、调试 UI 行为、捕获浏览器截图和查看浏览器日志。
license: Complete terms in LICENSE.txt
---

# Web Application Testing（Web 应用测试）

要测试本地 web 应用，编写原生 Python Playwright 脚本。

**可用的 Helper Scripts**：
- `scripts/with_server.py` - 管理服务器生命周期（支持多个服务器）

**始终先用 `--help` 运行脚本** 查看用法。不要先读源码，直到你尝试运行脚本后发现确实需要定制方案。这些脚本可能非常大，会污染你的 context window。它们的存在是为了作为黑盒脚本直接调用，而非加载到 context window 中。

## Decision Tree: Choosing Your Approach（决策树：选择你的方法）

```
用户任务 → 是静态 HTML 吗？
    ├─ 是 → 直接读取 HTML 文件以识别 selectors
    │         ├─ 成功 → 使用 selectors 编写 Playwright 脚本
    │         └─ 失败/不完整 → 当作动态处理（见下）
    │
    └─ 否（动态 webapp）→ 服务器已经在运行吗？
        ├─ 否 → 运行: python scripts/with_server.py --help
        │        然后使用 helper + 编写简化的 Playwright 脚本
        │
        └─ 是 → 侦察-然后-行动：
            1. 导航并等待 networkidle
            2. 截图或检查 DOM
            3. 从渲染状态识别 selectors
            4. 用发现的 selectors 执行操作
```

## Example: Using with_server.py（示例：使用 with_server.py）

要启动服务器，先运行 `--help`，然后使用 helper：

**单个服务器：**
```bash
python scripts/with_server.py --server "npm run dev" --port 5173 -- python your_automation.py
```

**多个服务器（例如后端 + 前端）：**
```bash
python scripts/with_server.py \
  --server "cd backend && python server.py" --port 3000 \
  --server "cd frontend && npm run dev" --port 5173 \
  -- python your_automation.py
```

创建自动化脚本时，只包含 Playwright 逻辑（服务器自动管理）：
```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True) # 始终以 headless 模式启动 chromium
    page = browser.new_page()
    page.goto('http://localhost:5173') # 服务器已在运行且就绪
    page.wait_for_load_state('networkidle') # 关键：等待 JS 执行完成
    # ... 你的自动化逻辑
    browser.close()
```

## Reconnaissance-Then-Action Pattern（侦察-然后-行动模式）

1. **检查渲染后的 DOM**：
   ```python
   page.screenshot(path='/tmp/inspect.png', full_page=True)
   content = page.content()
   page.locator('button').all()
   ```

2. **从检查结果中识别 selectors**

3. **使用发现的 selectors 执行操作**

## Common Pitfall（常见陷阱）

❌ **不要** 在动态应用上等待 `networkidle` 之前检查 DOM
✅ **要** 在检查前等待 `page.wait_for_load_state('networkidle')`

## Best Practices（最佳实践）

- **将捆绑脚本作为黑盒使用** — 要完成任务时，考虑 `scripts/` 中是否有可用的脚本。这些脚本可靠地处理常见复杂工作流，而不会弄乱 context window。使用 `--help` 查看用法，然后直接调用。
- 对同步脚本使用 `sync_playwright()`
- 完成后始终关闭浏览器
- 使用描述性 selectors：`text=`、`role=`、CSS selectors 或 IDs
- 添加适当的等待：`page.wait_for_selector()` 或 `page.wait_for_timeout()`

## Reference Files（参考文件）

- **examples/** - 展示常见模式的示例：
  - `element_discovery.py` - 在页面上发现按钮、链接和输入框
  - `static_html_automation.py` - 对本地 HTML 使用 file:// URL
  - `console_logging.py` - 在自动化期间捕获控制台日志
