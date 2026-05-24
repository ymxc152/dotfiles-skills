---
name: mcp-builder
description: 创建高质量 MCP（Model Context Protocol）服务器的指南，使 LLM 能通过精心设计的工具与外部服务交互。当使用 Python（FastMCP）或 Node/TypeScript（MCP SDK）构建 MCP 服务器来集成外部 API 或服务时使用。
license: Complete terms in LICENSE.txt
---

# MCP Server Development Guide（MCP 服务器开发指南）

## Overview（概述）

创建 MCP（Model Context Protocol）服务器，使 LLM 能通过精心设计的工具与外部服务交互。MCP 服务器的质量取决于它帮助 LLM 完成现实世界任务的能力。

---

# Process（流程）

## 高级工作流

创建高质量 MCP 服务器涉及四个主要阶段：

### Phase 1: 深入研究与规划

#### 1.1 理解现代 MCP 设计

**API 覆盖 vs 工作流工具：**
在全面的 API endpoint 覆盖与 specialized 工作流工具之间取得平衡。工作流工具对特定任务更方便，而全面覆盖给 agent 组合操作的灵活性。不同客户端性能不同——有些受益于结合基本工具的代码执行，有些则更擅长高级工作流。不确定时，优先全面 API 覆盖。

**工具命名与可发现性：**
清晰、描述性的工具名称帮助 agent 快速找到正确工具。使用一致前缀（例如 `github_create_issue`、`github_list_repos`）和面向动作的命名。

**上下文管理：**
Agent 受益于简洁的工具描述和过滤/分页结果的能力。设计返回聚焦、相关数据的工具。某些客户端支持代码执行，帮助 agent 高效过滤和处理数据。

**可操作的错误消息：**
错误消息应通过具体建议和下一步引导 agent 走向解决方案。

#### 1.2 学习 MCP 协议文档

从 sitemap 开始找到相关页面：`https://modelcontextprotocol.io/sitemap.xml`

然后用 `.md` 后缀获取特定页面（例如 `https://modelcontextprotocol.io/specification/draft.md`）。

关键页面：
- 规范概述和架构
- 传输机制（streamable HTTP、stdio）
- Tool、resource 和 prompt 定义

#### 1.3 学习框架文档

**推荐技术栈：**
- **语言**：TypeScript（高质量 SDK 支持和良好兼容性。AI 模型擅长生成 TypeScript 代码）
- **传输**：远程服务器使用 Streamable HTTP（无状态 JSON，更简单），本地服务器使用 stdio

**加载框架文档：**

- **MCP 最佳实践**：[📋 View Best Practices](./reference/mcp_best_practices.md) - 核心指南

**TypeScript（推荐）：**
- **TypeScript SDK**：使用 WebFetch 加载 `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`
- [⚡ TypeScript Guide](./reference/node_mcp_server.md) - TypeScript 模式和示例

**Python：**
- **Python SDK**：使用 WebFetch 加载 `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`
- [🐍 Python Guide](./reference/python_mcp_server.md) - Python 模式和示例

#### 1.4 规划你的实现

**理解 API：**
查看服务的 API 文档，识别关键 endpoints、认证要求和数据模型。

**工具选择：**
优先全面 API 覆盖。列出要实现的 endpoints，从最常见操作开始。

---

### Phase 2: 实现

#### 2.1 设置项目结构

参见语言特定指南：
- [⚡ TypeScript Guide](./reference/node_mcp_server.md) - 项目结构、package.json、tsconfig.json
- [🐍 Python Guide](./reference/python_mcp_server.md) - 模块组织、依赖

#### 2.2 实现核心基础设施

创建共享工具：
- 带认证的 API client
- 错误处理 helpers
- 响应格式化（JSON/Markdown）
- 分页支持

#### 2.3 实现工具

对于每个工具：

**Input Schema：**
- TypeScript 使用 Zod，Python 使用 Pydantic
- 包含约束和清晰描述
- 在字段描述中添加示例

**Output Schema：**
- 为结构化数据定义 `outputSchema`
- 在工具响应中使用 `structuredContent`（TypeScript SDK 特性）

**Tool Description：**
- 功能简洁摘要
- 参数描述
- 返回类型 schema

**Implementation：**
- I/O 操作使用 async/await
- 带有可操作消息的错误处理
- 支持分页
- 使用现代 SDK 时返回 text content 和 structured data

**Annotations：**
- `readOnlyHint`: true/false
- `destructiveHint`: true/false
- `idempotentHint`: true/false
- `openWorldHint`: true/false

---

### Phase 3: 审查与测试

#### 3.1 代码质量

审查：
- 无重复代码（DRY 原则）
- 一致的错误处理
- 完整类型覆盖
- 清晰的工具描述

#### 3.2 构建与测试

**TypeScript：**
- 运行 `npm run build` 验证编译
- 使用 MCP Inspector 测试：`npx @modelcontextprotocol/inspector`

**Python：**
- 验证语法：`python -m py_compile your_server.py`
- 使用 MCP Inspector 测试

---

### Phase 4: 创建 Evaluations

实现 MCP 服务器后，创建全面的 evaluations 来测试其有效性。

**加载 [✅ Evaluation Guide](./reference/evaluation.md) 获取完整指南。**

#### 4.1 理解 Evaluation 目的

使用 evaluations 测试 LLM 是否能有效使用你的 MCP 服务器回答现实、复杂的问题。

#### 4.2 创建 10 个 Evaluation 问题

1. **工具检查**：列出可用工具并理解其能力
2. **内容探索**：使用只读操作探索可用数据
3. **问题生成**：创建 10 个复杂、现实的问题
4. **答案验证**：自己解决每个问题以验证答案

#### 4.3 Evaluation 要求

确保每个问题：
- **Independent**：不依赖其他问题
- **Read-only**：只需要非破坏性操作
- **Complex**：需要多个工具调用和深入探索
- **Realistic**：基于人类关心的真实用例
- **Verifiable**：单一、清晰的答案可通过字符串比较验证
- **Stable**：答案不会随时间改变

#### 4.4 输出格式

创建 XML 文件：
```xml
<evaluation>
  <qa_pair>
    <question>...</question>
    <answer>...</answer>
  </qa_pair>
</evaluation>
```

---

# Reference Files（参考文件）

## 📚 文档库

按需加载这些资源：

### Core MCP Documentation（核心 MCP 文档）（首先加载）
- **MCP Protocol**：从 `https://modelcontextprotocol.io/sitemap.xml` 开始，然后获取 `.md` 后缀的特定页面
- [📋 MCP Best Practices](./reference/mcp_best_practices.md) - 通用 MCP 指南

### SDK 文档（Phase 1/2 期间加载）
- **Python SDK**：Fetch `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`
- **TypeScript SDK**：Fetch `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`

### 语言特定实现指南（Phase 2 期间加载）
- [🐍 Python Implementation Guide](./reference/python_mcp_server.md) - 完整 Python/FastMCP 指南
- [⚡ TypeScript Implementation Guide](./reference/node_mcp_server.md) - 完整 TypeScript 指南

### Evaluation Guide（Phase 4 期间加载）
- [✅ Evaluation Guide](./reference/evaluation.md) - 完整 evaluation 创建指南
