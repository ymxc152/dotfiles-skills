---
name: frontend-design
description: 创建具有高品质设计的独特、生产级前端界面。当用户要求构建 web 组件、页面、产物、海报或应用时使用（包括网站、landing page、dashboard、React 组件、HTML/CSS 布局或为任何 web UI 添加样式/美化）。生成有创意的、精美的代码和 UI 设计，避免 generic AI 审美。
license: Complete terms in LICENSE.txt
---

本 skill 指导创建独特的、生产级前端界面，避免 generic 的 "AI slop" 审美。实现具有卓越审美细节和创造性选择的真实工作代码。

用户提供前端需求：要构建的组件、页面、应用或界面。他们可能包含关于目的、受众或技术约束的上下文。

## Design Thinking（设计思考）

在编码之前，理解上下文并承诺一个**大胆**的美学方向：
- **Purpose（目的）**：这个界面解决什么问题？谁使用它？
- **Tone（调性）**：选择一个极端：极简、极繁混沌、复古未来主义、有机/自然、奢华/精致、 playful/toy-like、 editorial/magazine、 brutalist/raw、 art deco/geometric、 soft/pastel、 industrial/utilitarian 等。有很多风味可选。用它们获取灵感，但要设计一个忠于美学方向的风格。
- **Constraints（约束）**：技术要求（框架、性能、可访问性）。
- **Differentiation（差异化）**：什么让这个界面**难忘**？有人会记住的那一件事是什么？

**关键**：选择一个清晰的概念方向并精准执行。大胆极繁和精致极简都有效——关键是 intentionality，而非 intensity。

然后实现工作代码（HTML/CSS/JS、React、Vue 等），它应该是：
- 生产级且功能完整
- 视觉醒目且令人难忘
- 具有清晰美学观点的 cohesive
- 每个细节都精心打磨

## Frontend Aesthetics Guidelines（前端美学准则）

关注：
- **Typography（排版）**：选择美丽、独特、有趣的字体。避免 generic 字体如 Arial 和 Inter；选择能提升前端美学的 distinctive 字体——意想不到、有个性的字体选择。将 distinctive display font 与 refined body font 搭配。
- **Color & Theme（颜色与主题）**：承诺一个 cohesive 美学。使用 CSS variables 保持一致性。主导色配 sharp accents 胜过胆怯、均匀分布的调色板。
- **Motion（动效）**：将动画用于效果和微交互。对于 HTML 优先使用 CSS-only 解决方案。React 中可用时使用 Motion 库。关注高影响力时刻：一个精心编排的页面加载配合 staggered reveals（animation-delay）比分散的微交互创造更多愉悦感。使用 scroll-triggering 和令人惊喜的 hover states。
- **Spatial Composition（空间构图）**：意想不到的布局。不对称。重叠。对角线流动。打破网格的元素。慷慨的负空间或有控制的密度。
- **Backgrounds & Visual Details（背景与视觉细节）**：创造氛围和深度，而非默认使用纯色。添加与整体美学匹配的 contextual effects 和 textures。应用 creative forms 如 gradient meshes、noise textures、geometric patterns、layered transparencies、dramatic shadows、decorative borders、custom cursors 和 grain overlays。

永远不要使用 generic AI 生成美学，如过度使用的字体家族（Inter、Roboto、Arial、system fonts）、陈词滥调的颜色方案（特别是白色背景上的紫色渐变）、可预测的布局和组件模式、缺乏上下文特定特征的 cookie-cutter 设计。

创造性地解释并做出意想不到的选择，让人感觉 genuinely designed for the context。没有设计应该是相同的。在 light 和 dark 主题、不同字体、不同美学之间变化。永远不要收敛到常见选择（例如 Space Grotesk）。

**重要**：将实现复杂度与美学愿景匹配。极繁设计需要包含大量动画和效果的 elaborate code。极简或精致设计需要克制、 precision，以及对 spacing、typography 和 subtle details 的仔细关注。优雅来自于很好地执行愿景。

记住：Claude 能够进行非凡的创造性工作。不要退缩，展示当跳出框框思考并完全致力于独特愿景时，真正能创造什么。
