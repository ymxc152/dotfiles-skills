---
name: sharp-edges
description: "识别容易出错的 API、危险的配置和 footgun 设计，这些设计会导致安全错误。在审查 API 设计、配置 schema、加密库人体工程学，或评估代码是否遵循 'secure by default' 和 'pit of success' 原则时使用。触发词：footgun、misuse-resistant、secure defaults、API usability、dangerous configuration。"
allowed-tools: Read Grep Glob
---

# Sharp Edges Analysis（Sharp Edges 分析）

评估 API、配置和接口是否能抵抗开发者误用。识别"简单路径"导致不安全的设计。

## When to Use（何时使用）

- 审查 API 或库设计决策
- 审计配置 schema 中的危险选项
- 评估加密 API 人体工程学
- 评估认证/授权接口
- 审查任何向开发者暴露安全相关选择的代码

## When NOT to Use（何时不使用）

- 实现 Bug（使用标准代码审查）
- 业务逻辑缺陷（使用领域特定分析）
- 性能优化（不同关注点）

## Core Principle（核心原则）

**The pit of success**：安全使用应该是最小阻力路径。如果开发者必须理解密码学、仔细阅读文档或记住特殊规则来避免漏洞，API 就失败了。

## Rationalizations to Reject（要拒绝的合理化）

| 合理化 | 为什么错误 | 必需行动 |
|-----------------|----------------|-----------------|
| "It's documented" | 开发者在截止日期压力下不读文档 | 让安全选择成为默认或唯一选项 |
| "Advanced users need flexibility" | 灵活性创造 footguns；大多数"高级"用法是复制粘贴 | 提供安全的高级 API；隐藏原始原语 |
| "It's the developer's responsibility" | 推卸责任；你设计了这个 footgun | 移除 footgun 或让误用不可能 |
| "Nobody would actually do that" | 开发者在压力下会做一切想象得到的事 | 假设最大开发者困惑 |
| "It's just a configuration option" | 配置就是代码；错误配置会进入生产 | 验证配置；拒绝危险组合 |
| "We need backwards compatibility" | 不安全默认值不能被 grandfather-claused | 大声弃用；强制迁移 |

## Sharp Edge Categories（Sharp Edge 类别）

### 1. Algorithm/Mode Selection Footguns（算法/模式选择 Footguns）

让开发者选择算法的 API 会邀请选择错误。

**The JWT Pattern**（典型示例）：
- Header 指定算法：攻击者可设置 `"alg": "none"` 绕过签名
- Algorithm confusion：切换 RS256→HS256 时 RSA 公钥被用作 HMAC secret
- 根本原因：让不可信输入控制安全关键决策

**检测模式：**
- `algorithm`、`mode`、`cipher`、`hash_type` 等函数参数
- 选择加密原语的 Enums/strings
- 安全机制的配置选项

### 2. Dangerous Defaults（危险默认值）

不安全或零/空值禁用安全的默认值。

**检测模式：**
- 接受 0 的 timeouts/lifetimes（无限？立即过期？）
- 绕过检查的空字符串
- 跳过验证的 null 值
- 禁用安全功能的布尔默认值
- 语义未定义的负值

### 3. Primitive vs. Semantic APIs（原始 vs 语义 API）

暴露原始字节而非有意义类型的 API 会邀请类型混淆。

**The Libsodium vs. Halite Pattern：**
```php
// Libsodium（原语）：bytes 就是 bytes
sodium_crypto_box($message, $nonce, $keypair);
// 容易：交换 nonce/keypair、重用 nonces、使用错误 key 类型

// Halite（语义）：类型强制执行正确使用
Crypto::seal($message, new EncryptionPublicKey($key));
// 错误 key 类型 = 类型错误，而非静默失败
```

### 4. Configuration Cliffs（配置悬崖）

一个错误设置就导致灾难性失败，且没有警告。

**检测模式：**
- 完全禁用安全的布尔标志
- 未验证的字符串配置
- 危险交互的设置组合
- 覆盖安全设置的环境变量
- 有合理默认值但无验证的构造函数参数

### 5. Silent Failures（静默失败）

错误不浮出水面，或成功掩盖失败。

**检测模式：**
- 安全失败时返回布尔值而非抛出异常的函数
- 安全操作周围的空 catch 块
- 解析错误时替换默认值
- 对畸形输入"成功"的验证函数

### 6. Stringly-Typed Security（字符串类型的安全）

安全关键值作为纯字符串启用注入和混淆。

**检测模式：**
- 从字符串拼接构建的 SQL/commands
- 逗号分隔字符串的权限
- 任意字符串而非 enums 的 Roles/scopes
- 通过拼接字符串构建的 URLs

## Analysis Workflow（分析工作流）

### Phase 1: Surface Identification（表面识别）

1. **映射安全相关 API**：认证、授权、密码学、session 管理、输入验证
2. **识别开发者选择点**：开发者可以在哪里选择算法、配置 timeouts、选择模式？
3. **找到配置 schema**：环境变量、配置文件、构造函数参数

### Phase 2: Edge Case Probing（边界情况探测）

对于每个选择点，问：
- **Zero/empty/null**：`0`、`""`、`null`、`[]` 会发生什么？
- **Negative values**：`-1` 意味着什么？无限？错误？
- **Type confusion**：不同安全概念可以互换吗？
- **Default values**：默认是安全的吗？有文档吗？
- **Error paths**：无效输入时会发生什么？静默接受？

### Phase 3: Threat Modeling（威胁建模）

考虑三个对手：

1. **The Scoundrel（恶棍）**：积极恶意的开发者或控制配置的攻击者
2. **The Lazy Developer（懒惰开发者）**：复制粘贴示例、跳过文档
3. **The Confused Developer（困惑开发者）**：误解 API

### Phase 4: Validate Findings（验证发现）

对于每个识别的 sharp edge：
1. **复现误用**：编写演示 footgun 的最小代码
2. **验证可利用性**：误用是否创建了真实漏洞？
3. **检查文档**：危险是否有文档？（文档不能为坏设计开脱，但影响严重性）
4. **测试缓解**：API 能否以合理努力安全使用？

## Severity Classification（严重性分类）

| 严重性 | 标准 | 示例 |
|----------|----------|--------|
| Critical | 默认或明显用法不安全 | `verify: false` 默认；允许空密码 |
| High | 容易的错误配置破坏安全 | 算法参数接受 "none" |
| Medium | 不寻常但可能的错误配置 | 负 timeout 有意想不到的含义 |
| Low | 需要故意误用 | 晦涩的参数组合 |

## Quality Checklist（质量检查清单）

分析结束前：

- [ ] 探测了所有 zero/empty/null 边界情况
- [ ] 验证了默认是安全的
- [ ] 检查了算法/模式选择 footguns
- [ ] 测试了安全概念之间的类型混淆
- [ ] 考虑了所有三种对手类型
- [ ] 验证了错误路径不绕过安全
- [ ] 检查了配置验证
- [ ] 构造函数参数已验证（不只是默认）
