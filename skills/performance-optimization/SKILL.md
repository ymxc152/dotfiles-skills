---
name: performance-optimization
description: 优化应用性能。当存在性能要求、怀疑性能回归、或 Core Web Vitals 或加载时间需要改进时使用。当 profiling 揭示需要修复的瓶颈时使用。
---

# Performance Optimization（性能优化）

## Overview（概述）

测量后再优化。没有测量的性能工作是猜测——猜测导致过早优化，增加复杂性而不改善重要指标。先 profiling，识别实际瓶颈，修复它，再测量。只优化测量证明重要的东西。

## When to Use（何时使用）

- 性能要求存在于 spec 中（加载时间预算、响应时间 SLA）
- 用户或监控报告缓慢行为
- Core Web Vitals 分数低于阈值
- 怀疑更改引入了回归
- 构建处理大数据集或高流量的功能

**何时不使用：** 没有证据证明有问题之前不要优化。过早优化增加的复杂性比它获得的性能更昂贵。

## Core Web Vitals Targets（Core Web Vitals 目标）

| 指标 | 良好 | 需要改进 | 差 |
|------|------|---------|-----|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | ≤ 4.0s | > 4.0s |
| **INP** (Interaction to Next Paint) | ≤ 200ms | ≤ 500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | ≤ 0.25 | > 0.25 |

## The Optimization Workflow（优化工作流）

```
1. MEASURE  → 用真实数据建立基线
2. IDENTIFY → 找到实际瓶颈（非假设的）
3. FIX      → 解决特定瓶颈
4. VERIFY   → 再次测量，确认改进
5. GUARD    → 添加监控或测试防止回归
```

### Step 1: Measure（测量）

两种互补方法——都使用：

- **Synthetic (Lighthouse, DevTools Performance tab)：** 受控条件，可复现。最适合 CI 回归检测和隔离特定问题。
- **RUM (web-vitals library, CrUX)：** 真实用户真实条件下的数据。需要验证修复是否实际改善了用户体验。

**前端：**
```bash
# Synthetic：Chrome DevTools 中的 Lighthouse（或 CI）
# RUM：代码中的 Web Vitals 库
import { onLCP, onINP, onCLS } from 'web-vitals';
onLCP(console.log);
onINP(console.log);
onCLS(console.log);
```

**后端：**
```bash
# 简单计时
console.time('db-query');
const result = await db.query(...);
console.timeEnd('db-query');
```

### Step 2: Identify the Bottleneck（识别瓶颈）

**前端常见瓶颈：**

| 症状 | 可能原因 | 调查 |
|---------|-------------|---------------|
| Slow LCP | 大图、render-blocking 资源、慢服务器 | 检查 network waterfall、图片大小 |
| High CLS | 无尺寸图片、延迟加载内容、字体偏移 | 检查 layout shift attribution |
| Poor INP | 主线程上沉重的 JavaScript、大 DOM 更新 | 检查 Performance trace 中的 long tasks |
| 慢初始加载 | 大包、多网络请求 | 检查 bundle size、code splitting |

**后端常见瓶颈：**

| 症状 | 可能原因 | 调查 |
|---------|-------------|---------------|
| 慢 API 响应 | N+1 查询、缺少索引、未优化查询 | 检查数据库查询日志 |
| 内存增长 | 泄漏引用、无界缓存、大 payload | Heap snapshot 分析 |
| CPU 飙升 | 同步重计算、regex backtracking | CPU profiling |
| 高延迟 | 缺少缓存、冗余计算、网络跳转 | Trace requests through the stack |

### Step 3: Fix Common Anti-Patterns（修复常见反模式）

#### N+1 Queries（后端）

```typescript
// 坏: N+1 — 每个 task 一个 owner 查询
const tasks = await db.tasks.findMany();
for (const task of tasks) {
  task.owner = await db.users.findUnique({ where: { id: task.ownerId } });
}

// 好: 单次查询带 join/include
const tasks = await db.tasks.findMany({ include: { owner: true } });
```

#### Missing Image Optimization（前端）

```html
<!-- 坏: 无尺寸、无格式优化 -->
<img src="/hero.jpg" />

<!-- 好: LCP 图片 — art direction + resolution switching，高优先级 -->
<picture>
  <source srcset="/hero-800.avif 800w, /hero-1200.avif 1200w" sizes="(max-width: 1200px) 100vw, 1200px" type="image/avif" />
  <img src="/hero-desktop.jpg" width="1200" height="600" fetchpriority="high" alt="Hero" />
</picture>

<!-- 好: 视口下方图片 — lazy loaded + async decoding -->
<img src="/content.webp" width="800" height="400" loading="lazy" decoding="async" alt="Content" />
```

#### Unnecessary Re-renders（React）

```tsx
// 坏: 每次渲染创建新对象，导致子组件重新渲染
function TaskList() {
  return <TaskFilters options={{ sortBy: 'date', order: 'desc' }} />;
}

// 好: 稳定引用
const DEFAULT_OPTIONS = { sortBy: 'date', order: 'desc' } as const;
function TaskList() {
  return <TaskFilters options={DEFAULT_OPTIONS} />;
}

// 好: Dynamic import 用于沉重、很少使用的功能
const ChartLibrary = lazy(() => import('./ChartLibrary'));
```

#### Missing Caching（后端）

```typescript
// 缓存频繁读取、很少更改的数据
const CACHE_TTL = 5 * 60 * 1000;
let cachedConfig: AppConfig | null = null;
let cacheExpiry = 0;

async function getAppConfig(): Promise<AppConfig> {
  if (cachedConfig && Date.now() < cacheExpiry) return cachedConfig;
  cachedConfig = await db.config.findFirst();
  cacheExpiry = Date.now() + CACHE_TTL;
  return cachedConfig;
}

// 静态资源的 HTTP 缓存头
app.use('/static', express.static('public', { maxAge: '1y', immutable: true }));
```

## Performance Budget（性能预算）

设置预算并强制执行：

```
JavaScript bundle: < 200KB gzipped（初始加载）
CSS: < 50KB gzipped
Images: < 200KB 每张（首屏）
Fonts: < 100KB 总计
API response time: < 200ms (p95)
Time to Interactive: < 3.5s on 4G
Lighthouse Performance score: ≥ 90
```

**在 CI 中强制执行：**
```bash
npx bundlesize --config bundlesize.config.json
npx lhci autorun
```

## Red Flags（危险信号）

- 没有 profiling 数据就优化
- 数据获取中的 N+1 查询模式
- list endpoints 没有分页
- 无尺寸、无 lazy loading、无响应式尺寸的图片
- Bundle size 未经审查就增长
- 生产环境没有性能监控
- 到处使用 `React.memo` 和 `useMemo`（过度使用和不足一样糟）

## Verification（验证）

任何性能相关更改后：

- [ ] 存在前后测量（具体数字）
- [ ] 特定瓶颈被识别并解决
- [ ] Core Web Vitals 在"良好"阈值内
- [ ] Bundle size 没有显著增加
- [ ] 新数据获取代码中没有 N+1 查询
- [ ] CI 中性能预算通过（如果配置）
- [ ] 现有测试仍然通过（优化没有破坏行为）
