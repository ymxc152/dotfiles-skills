---
name: security-and-hardening
description: 加固代码以抵御漏洞。在处理用户输入、认证、数据存储或外部集成时使用。在构建任何接受不可信数据、管理用户会话或与第三方服务交互的功能时使用。
---

# Security and Hardening（安全与加固）

## Overview（概述）

Web 应用的安全优先开发实践。将每个外部输入视为敌对，每个 secret 视为神圣，每个授权检查视为强制。安全不是一个阶段——它是每行触及用户数据、认证或外部系统的代码的约束。

## When to Use（何时使用）

- 构建任何接受用户输入的东西
- 实现认证或授权
- 存储或传输敏感数据
- 与外部 API 或服务集成
- 添加文件上传、webhooks 或 callbacks
- 处理支付或 PII 数据

## The Three-Tier Boundary System（三层边界系统）

### Always Do（必须做，无例外）

- **验证所有外部输入** 在系统边界（API routes、form handlers）
- **参数化所有数据库查询** — 永远不要将用户输入拼接进 SQL
- **编码输出** 以防止 XSS（使用框架自动转义，不要绕过它）
- **使用 HTTPS** 进行所有外部通信
- **使用 bcrypt/scrypt/argon2 哈希密码**（绝不存储明文）
- **设置安全头**（CSP、HSTS、X-Frame-Options、X-Content-Type-Options）
- **使用 httpOnly、secure、sameSite cookies** 用于 sessions
- **每次发布前运行 `npm audit`**（或等效工具）

### Ask First（先询问，需要人类批准）

- 添加新的认证流程或更改 auth 逻辑
- 存储新类别的敏感数据（PII、支付信息）
- 添加新的外部服务集成
- 更改 CORS 配置
- 添加文件上传处理程序
- 修改 rate limiting 或 throttling
- 授予提升的权限或角色

### Never Do（绝不做）

- **不要将 secrets 提交到版本控制**（API keys、密码、tokens）
- **不要记录敏感数据**（密码、tokens、完整信用卡号）
- **不要将客户端验证作为安全边界信任**
- **不要为了便利禁用安全头**
- **不要对用户提供的数据使用 `eval()` 或 `innerHTML`**
- **不要将 sessions 存储在客户端可访问的存储中**（localStorage 用于 auth tokens）
- **不要向用户暴露 stack traces 或内部错误详情**

## OWASP Top 10 Prevention（OWASP Top 10 预防）

### 1. Injection（注入）（SQL、NoSQL、OS Command）

```typescript
// 坏: 通过字符串拼接的 SQL 注入
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// 好: 参数化查询
const user = await db.query('SELECT * FROM users WHERE id = $1', [userId]);

// 好: 带参数化输入的 ORM
const user = await prisma.user.findUnique({ where: { id: userId } });
```

### 2. Broken Authentication（认证失效）

```typescript
// 密码哈希
import { hash, compare } from 'bcrypt';
const SALT_ROUNDS = 12;
const hashedPassword = await hash(plaintext, SALT_ROUNDS);
const isValid = await compare(plaintext, hashedPassword);

// Session 管理
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    maxAge: 24 * 60 * 60 * 1000,
  },
}));
```

### 3. Cross-Site Scripting (XSS)

```typescript
// 坏: 将用户输入渲染为 HTML
element.innerHTML = userInput;

// 好: 使用框架自动转义（React 默认这样做）
return <div>{userInput}</div>;

// 如果必须渲染 HTML，先 sanitize
import DOMPurify from 'dompurify';
const clean = DOMPurify.sanitize(userInput);
```

### 4. Broken Access Control（访问控制失效）

```typescript
// 始终检查授权，不只是认证
app.patch('/api/tasks/:id', authenticate, async (req, res) => {
  const task = await taskService.findById(req.params.id);
  if (task.ownerId !== req.user.id) {
    return res.status(403).json({ error: { code: 'FORBIDDEN', message: 'Not authorized' } });
  }
  const updated = await taskService.update(req.params.id, req.body);
  return res.json(updated);
});
```

### 5. Security Misconfiguration（安全配置错误）

```typescript
import helmet from 'helmet';
app.use(helmet());

// Content Security Policy
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", 'data:', 'https:'],
  },
}));

// CORS — 限制到已知来源
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || 'http://localhost:3000',
  credentials: true,
}));
```

### 6. Sensitive Data Exposure（敏感数据暴露）

```typescript
// 绝不在 API 响应中返回敏感字段
function sanitizeUser(user: UserRecord): PublicUser {
  const { passwordHash, resetToken, ...publicFields } = user;
  return publicFields;
}

// 使用环境变量存储 secrets
const API_KEY = process.env.STRIPE_API_KEY;
if (!API_KEY) throw new Error('STRIPE_API_KEY not configured');
```

## Input Validation Patterns（输入验证模式）

### Schema Validation at Boundaries（边界处的 Schema 验证）

```typescript
import { z } from 'zod';

const CreateTaskSchema = z.object({
  title: z.string().min(1).max(200).trim(),
  description: z.string().max(2000).optional(),
  priority: z.enum(['low', 'medium', 'high']).default('medium'),
});

app.post('/api/tasks', async (req, res) => {
  const result = CreateTaskSchema.safeParse(req.body);
  if (!result.success) {
    return res.status(422).json({ error: { code: 'VALIDATION_ERROR', details: result.error.flatten() } });
  }
  const task = await taskService.create(result.data);
  return res.status(201).json(task);
});
```

### File Upload Safety（文件上传安全）

```typescript
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp'];
const MAX_SIZE = 5 * 1024 * 1024; // 5MB

function validateUpload(file: UploadedFile) {
  if (!ALLOWED_TYPES.includes(file.mimetype)) {
    throw new ValidationError('File type not allowed');
  }
  if (file.size > MAX_SIZE) {
    throw new ValidationError('File too large (max 5MB)');
  }
}
```

## Rate Limiting（速率限制）

```typescript
import rateLimit from 'express-rate-limit';

app.use('/api/', rateLimit({
  windowMs: 15 * 60 * 1000, // 15 分钟
  max: 100,
}));

app.use('/api/auth/', rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,  // auth endpoints 更严格
}));
```

## Secrets Management（Secrets 管理）

```
.env files:
  ├── .env.example  → 已提交（带占位值的模板）
  ├── .env          → 不提交（包含真实 secrets）
  └── .env.local    → 不提交（本地覆盖）

.gitignore 必须包含:
  .env
  .env.local
  .env.*.local
  *.pem
  *.key
```

## Security Review Checklist（安全审查检查清单）

```markdown
### Authentication
- [ ] 密码使用 bcrypt/scrypt/argon2 哈希（salt rounds ≥ 12）
- [ ] Session tokens 是 httpOnly、secure、sameSite
- [ ] Login 有 rate limiting
- [ ] Password reset tokens 有过期时间

### Authorization
- [ ] 每个 endpoint 检查用户权限
- [ ] 用户只能访问自己的资源
- [ ] Admin 操作需要 admin role 验证

### Input
- [ ] 所有用户输入在边界处验证
- [ ] SQL 查询已参数化
- [ ] HTML 输出已编码/转义

### Data
- [ ] 代码或版本控制中没有 secrets
- [ ] 敏感字段从 API 响应中排除
- [ ] PII 静态加密（如适用）

### Infrastructure
- [ ] 安全头已配置（CSP、HSTS 等）
- [ ] CORS 限制到已知来源
- [ ] 依赖已审计漏洞
- [ ] 错误消息不暴露内部信息
```

## Red Flags（危险信号）

- 用户输入直接传递到数据库查询、shell 命令或 HTML 渲染
- Secrets 在源代码或 commit history 中
- 没有认证或授权检查的 API endpoints
- 缺少 CORS 配置或通配符 (`*`) 来源
- 认证 endpoints 没有 rate limiting
- Stack traces 或内部错误暴露给用户
- 有已知 critical 漏洞的依赖
