---
name: frontend-ui-engineering
description: 构建生产级 UI。在构建或修改面向用户的界面时使用。在创建组件、实现布局、管理状态，或当输出需要看起来和感觉上都是生产级而非 AI 生成时使用。
---

# Frontend UI Engineering（前端 UI 工程）

## Overview（概述）

构建可访问、高性能、视觉精致的生产级用户界面。目标是看起来像顶级公司的 design-aware engineer 构建的 UI——而非 AI 生成的。这意味着真正的 design system 遵循、适当的可访问性、 thoughtful 交互模式，没有 generic "AI aesthetic"。

## When to Use（何时使用）

- 构建新 UI 组件或页面
- 修改现有面向用户的界面
- 实现响应式布局
- 添加交互性或状态管理
- 修复视觉或 UX 问题

## Component Architecture（组件架构）

### File Structure（文件结构）

将所有与组件相关的内容并列放置：

```
src/components/
  TaskList/
    TaskList.tsx          # 组件实现
    TaskList.test.tsx     # 测试
    TaskList.stories.tsx  # Storybook stories（如果使用）
    use-task-list.ts      # Custom hook（如果状态复杂）
    types.ts              # 组件特定类型（如果需要）
```

### Component Patterns（组件模式）

**优先组合而非配置：**

```tsx
// 好：可组合
<Card>
  <CardHeader>
    <CardTitle>Tasks</CardTitle>
  </CardHeader>
  <CardBody>
    <TaskList tasks={tasks} />
  </CardBody>
</Card>

// 避免：过度配置
<Card
  title="Tasks"
  headerVariant="large"
  bodyPadding="md"
  content={<TaskList tasks={tasks} />}
/>
```

**保持组件聚焦：**

```tsx
// 好：只做一件事
export function TaskItem({ task, onToggle, onDelete }: TaskItemProps) {
  return (
    <li className="flex items-center gap-3 p-3">
      <Checkbox checked={task.done} onChange={() => onToggle(task.id)} />
      <span className={task.done ? 'line-through text-muted' : ''}>{task.title}</span>
      <Button variant="ghost" size="sm" onClick={() => onDelete(task.id)}>
        <TrashIcon />
      </Button>
    </li>
  );
}
```

**将数据获取与展示分离：**

```tsx
// Container：处理数据
export function TaskListContainer() {
  const { tasks, isLoading, error } = useTasks();
  if (isLoading) return <TaskListSkeleton />;
  if (error) return <ErrorState message="Failed to load tasks" retry={refetch} />;
  if (tasks.length === 0) return <EmptyState message="No tasks yet" />;
  return <TaskList tasks={tasks} />;
}

// Presentation：处理渲染
export function TaskList({ tasks }: { tasks: Task[] }) {
  return (
    <ul role="list" className="divide-y">
      {tasks.map(task => <TaskItem key={task.id} task={task} />)}
    </ul>
  );
}
```

## State Management（状态管理）

**选择最简单的可行方案：**

```
Local state (useState)           → 组件特定 UI 状态
Lifted state                     → 2-3 个 sibling 组件共享
Context                          → 主题、认证、locale（读多写少）
URL state (searchParams)         → 过滤器、分页、可分享 UI 状态
Server state (React Query, SWR)  → 带缓存的远程数据
Global store (Zustand, Redux)    → 复杂客户端状态全应用共享
```

**避免 prop drilling 超过 3 层。** 如果你通过不使用它们的组件传递 props，引入 context 或重组组件树。

## Design System Adherence（遵循 Design System）

### Avoid the AI Aesthetic（避免 AI 审美）

AI 生成的 UI 有可识别的模式。避免所有：

| AI 默认 | 为什么有问题 | 生产级质量 |
|---|---|---|
| 到处都是紫色/靛蓝 | 模型默认视觉上"安全"的调色板，让每个应用看起来一样 | 使用项目实际的颜色调色板 |
| 过度渐变 | 渐变增加视觉噪音，与大多数 design system 冲突 | 与 design system 匹配的 flat 或 subtle 渐变 |
| 全是圆角 (rounded-2xl) | 最大圆角表示"友好"但忽略了真实设计中 corner radii 的层级 | design system 中一致的 border-radius |
| Generic hero sections | 模板驱动的布局与实际内容或用户需求无关 | Content-first layouts |
| Lorem ipsum 式文案 | 占位文本隐藏真实内容才会暴露的布局问题 | 真实的占位内容 |
| 到处超大 padding | 相等的慷慨 padding 破坏视觉层级并浪费屏幕空间 | 一致的 spacing scale |
| Stock card grids | 统一网格是忽略信息优先级和扫描模式的布局捷径 | Purpose-driven layouts |
| Shadow-heavy design | 分层阴影增加与内容竞争的深度，并拖慢低端设备渲染 | Subtle 或无阴影，除非 design system 指定 |

### Spacing and Layout（间距与布局）

使用一致的 spacing scale。不要发明值：

```css
/* 使用 scale：0.25rem 增量（或项目使用的） */
/* 好 */  padding: 1rem;      /* 16px */
/* 好 */  gap: 0.75rem;       /* 12px */
/* 坏 */   padding: 13px;      /* 不在任何 scale 上 */
/* 坏 */   margin-top: 2.3rem; /* 不在任何 scale 上 */
```

### Typography（排版）

尊重 type hierarchy：

```
h1 → Page title（每页一个）
h2 → Section title
h3 → Subsection title
body → 默认文本
small → 二级/辅助文本
```

不要跳过 heading 级别。不要对非 heading 内容使用 heading 样式。

### Color（颜色）

- 使用 semantic color tokens：`text-primary`、`bg-surface`、`border-default` — 而非原始 hex 值
- 确保足够对比度（正常文本 4.5:1，大文本 3:1）
- 不要仅依赖颜色传达信息（也要使用图标、文本或 pattern）

## Accessibility (WCAG 2.1 AA)（可访问性）

### Keyboard Navigation（键盘导航）

```tsx
// 每个交互元素必须键盘可访问
<button onClick={handleClick}>Click me</button>        // ✓ 默认可聚焦
<div onClick={handleClick}>Click me</div>               // ✗ 不可聚焦
<div role="button" tabIndex={0} onClick={handleClick}    // ✓ 但优先用 <button>
     onKeyDown={e => { if (e.key === 'Enter') handleClick(); }}>
  Click me
</div>
```

### ARIA Labels

```tsx
// 为缺少可见文本的交互元素加标签
<button aria-label="Close dialog"><XIcon /></button>
// 为表单输入加标签
<label htmlFor="email">Email</label>
<input id="email" type="email" />
```

### Focus Management

```tsx
function Dialog({ isOpen, onClose }: DialogProps) {
  const closeRef = useRef<HTMLButtonElement>(null);
  useEffect(() => { if (isOpen) closeRef.current?.focus(); }, [isOpen]);
  return (
    <dialog open={isOpen}>
      <button ref={closeRef} onClick={onClose}>Close</button>
    </dialog>
  );
}
```

### Meaningful Empty and Error States

```tsx
function TaskList({ tasks }: { tasks: Task[] }) {
  if (tasks.length === 0) {
    return (
      <div role="status" className="text-center py-12">
        <TasksEmptyIcon className="mx-auto h-12 w-12 text-muted" />
        <h3 className="mt-2 text-sm font-medium">No tasks</h3>
        <p className="mt-1 text-sm text-muted">Get started by creating a new task.</p>
        <Button className="mt-4" onClick={onCreateTask}>Create Task</Button>
      </div>
    );
  }
  return <ul role="list">...</ul>;
}
```

## Responsive Design（响应式设计）

Mobile first，然后扩展：

```tsx
<div className="
  grid grid-cols-1      /* Mobile：单列 */
  sm:grid-cols-2        /* Small：2 列 */
  lg:grid-cols-3        /* Large：3 列 */
  gap-4
">
```

在这些断点测试：320px、768px、1024px、1440px。

## Loading and Transitions（加载与过渡）

```tsx
// Skeleton loading（内容不用 spinner）
function TaskListSkeleton() {
  return (
    <div className="space-y-3" aria-busy="true" aria-label="Loading tasks">
      {Array.from({ length: 3 }).map((_, i) => (
        <div key={i} className="h-12 bg-muted animate-pulse rounded" />
      ))}
    </div>
  );
}

// 乐观更新提升感知速度
function useToggleTask() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: toggleTask,
    onMutate: async (taskId) => {
      await queryClient.cancelQueries({ queryKey: ['tasks'] });
      const previous = queryClient.getQueryData(['tasks']);
      queryClient.setQueryData(['tasks'], (old: Task[]) =>
        old.map(t => t.id === taskId ? { ...t, done: !t.done } : t)
      );
      return { previous };
    },
    onError: (_err, _taskId, context) => {
      queryClient.setQueryData(['tasks'], context?.previous);
    },
  });
}
```

## See Also（参见）

详细可访问性要求和测试工具，参见 `references/accessibility-checklist.md`。

## Red Flags（危险信号）

- 超过 200 行的组件（拆分它们）
- Inline styles 或任意 pixel 值
- 缺少 error states、loading states 或 empty states
- 没有键盘导航测试
- 颜色作为状态的唯一指示器（没有文本或图标的红/绿）
- Generic "AI look"（紫色渐变、超大 cards、stock layouts）

## Verification（验证）

构建 UI 后：

- [ ] 组件渲染无控制台错误
- [ ] 所有交互元素键盘可访问（Tab 遍历页面）
- [ ] Screen reader 能传达页面内容和结构
- [ ] 响应式：在 320px、768px、1024px、1440px 工作
- [ ] Loading、error 和 empty states 都处理了
- [ ] 遵循项目的 design system（spacing、colors、typography）
- [ ] dev tools 或 axe-core 中无可访问性警告
