---
title: "STML — SSOT Template Markup Language"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "框架无关的UI声明语言。用HTML5 data-*属性定义页面展示和行为，对OpenAPI进行符号验证，生成React代码。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — 框架无关的UI声明。

前端代码混合了两件事：**你的决策**和**框架接线**。调用哪个API、展示哪些字段、以什么顺序、在什么条件下——这些决策被埋在React hooks或Vue composables里。切换框架或重构时，决策被重新解读或丢失。

STML将两者分离。决策留在带`data-*`属性的标准HTML中。框架接线由生成器或LLM完成。

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub 仓库</a>

## 结构

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  你的决策。框架无关。
│  获取、展示、提交什么            │  任何重写都能存活。
├─────────────────────────────────┤
│  代码生成 / LLM                 │  生成框架接线。
│  React, Vue, Svelte, 任何框架   │  可替换。
├─────────────────────────────────┤
│  运行时 (artifacts/)            │  React TSX, Vue SFC 等。
│  hooks、状态、渲染              │  生成物。不要编辑。
└─────────────────────────────────┘
```

## 保留的内容

STML HTML中的一切都是用户决策：

- **调用哪些API端点** (`data-fetch`, `data-action`)
- **展示或收集哪些字段** (`data-bind`, `data-field`)
- **元素以什么顺序出现** (DOM结构)
- **外观如何** (Tailwind类、HTML标签)
- **用户看到什么文字** (标题、占位符、按钮标签)
- **什么条件控制可见性** (`data-state`)
- **什么组件处理特殊UX** (`data-component`)
- **列表行为** — 分页、排序、过滤

不是React，不是Vue。是页面做什么，用标准HTML5声明。

## 示例

```html
<main class="max-w-4xl mx-auto p-6">
  <h1 class="text-2xl font-bold mb-6">我的预约</h1>

  <section data-fetch="ListMyReservations"
           data-paginate data-sort="StartAt:desc" data-filter="Status">
    <ul data-each="reservations" class="space-y-3">
      <li class="flex justify-between p-4 border rounded">
        <span data-bind="RoomID" class="font-semibold"></span>
        <span data-bind="Status" class="text-sm text-gray-500"></span>
      </li>
    </ul>
    <p data-state="reservations.empty" class="text-gray-400">暂无预约</p>
  </section>

  <div data-action="CreateReservation">
    <input data-field="RoomID" type="number" placeholder="房间号" />
    <button type="submit">预约</button>
  </div>
</main>
```

同一文件可以生成不同目标：

| 目标 | 方法 |
|---|---|
| React TSX | `stml gen`（内置确定性代码生成） |
| Vue SFC | 将STML + OpenAPI交给LLM："用Vue实现" |
| Svelte | 将STML + OpenAPI交给LLM："用Svelte实现" |
| Flutter | 将STML + OpenAPI交给LLM："用Flutter实现" |

决策被保留。只有框架接线改变。

## 验证

内置验证器在代码生成前对STML进行OpenAPI交叉验证：

- operationId是否存在？HTTP方法是否正确？
- 请求字段、响应字段和参数是否匹配schema？
- 排序/过滤/包含列是否在允许列表内？
- 引用的组件是否存在？

在CI时而非运行时捕获前端-API不匹配。

```bash
stml validate specs/my-project    # 对OpenAPI进行12项符号检查
```

## data-* 属性

| 属性 | 声明内容 |
|---|---|
| `data-fetch` | 从GET端点加载数据 |
| `data-action` | 向POST/PUT/DELETE端点提交数据 |
| `data-field` | 收集请求体字段 |
| `data-bind` | 显示响应字段 |
| `data-param-*` | 操作需要路径/查询参数 |
| `data-each` | 遍历数组字段 |
| `data-state` | 条件显示 |
| `data-component` | 委托给自定义组件 |
| `data-paginate` | 分页列表 |
| `data-sort` | 可排序列表（默认列和方向） |
| `data-filter` | 可过滤列表（哪些列） |
| `data-include` | 包含关联资源 |

## 许可证

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
