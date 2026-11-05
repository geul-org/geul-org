---
title: "GEUL 语法"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "GEUL v1 语法规范。定义 16 位 WORD 之上的记录、四种 Kind、文档结构、Issuer 与公布规则。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL（General Encoding Unified Language）是一种供人与 AI 无歧义地相互交换信息的人工语言，也是一种二进制格式。

这些文档定义 GEUL v1 语法。当前版本是公布前的草案，可能会有变动。规范以 [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) 公开。

## 一览 {#한눈에-보기}

- 所有数据都是 **16 位 WORD** 的序列，以大端序书写。
- 数据的单位是**记录**。记录以一个 TAG WORD 开头，该 TAG WORD 说明记录的种类和长度。
- 记录有四种（**Kind**）。

| Kind | 作用 | 示例 |
|---|---|---|
| Reference | 指向对象 | Wikidata Q42、本文档内的 #7 |
| Value | 承载值本身 | 日期、数量、带语言标记的文本 |
| Edge | 把其他记录组合起来进行陈述 | "Q42 是人"、"Q42 的英文名称是 Douglas Adams" |
| Meta | 描述文档本身 | 规范版次、文档 ID、作者、签名 |

- 记录被装入一个**文档**。文档与 HTML 类似，分为 HEAD（Meta，以及文档整体的出处 SOURCE 及其 QUALIFIER）和 BODY（Reference、Value、Edge）。
- 文档由 **Issuer**（发布主体）发布，每个版本都由内容哈希固定。已公布的版本不再更改。

## 设计原则 {#설계-원칙}

1. **无需 Codec 手册即可跳过。** 记录的种类和长度位于 TAG WORD 的 16 位中。不了解解释方法（Codec 手册）的解码器也能数出记录并跳过它们。
2. **承载的是陈述，而不是事实。** 文档用 Meta 和依据 Edge 一并写明某条陈述由谁、在何时、源自什么。
3. **标识通过 Reference 完成。** 用 ID 指向，而不是用名称。名称用 Edge 附加。
4. **已公布的内容不再更改。** 修改的内容以新版本发布。文档内的 ID 跨版本指向同一个对象。
5. **留空。** 比特空间的大部分留给未来。直接码无法收回，因此只分配已确认使用频率的项目。

## 下级文档 {#하위-문서}

初次阅读时，请按表中自上而下的顺序阅读。

| 文档 | 内容 |
|---|---|
| [记录的结构](record.md) | TAG WORD 布局、Length、Codec、扩展 TAG |
| [Issuer 与公布](issuer.md) | Issuer 等级、2 WORD 分配表、公开方式、签名、验证密钥 |
| [公布地址与版本列表](publishing.md) | ID 写法、公布地址、格式指定、Issuer 列表、版本列表、信任层 |
| [Codec 规格文档](codec-spec.md) | 用 DECLARE、FIELD、ENUM、CODEC 书写的 Codec 手册 |
| [一般文档](document.md) | DOC、HEAD、BODY、END，文档 ID，内容哈希，版本与修订 |
| [代码索引](codec-index.md) | 全部 227 个已分配格位，按 Kind、系列划分的 Codec 表 |
| [章节布局](layout.md) | 16 个章节与格位布局，已分配与 Reserved 区间 |
| [占位标记](slot-marker.md) | ABSENT、UNKNOWN-VALUE、NO-VALUE，接受规则 |
| [Reference](reference/_index.md) | 对象标识、LOCAL、外部引用、Quantifier、占位标记 |
| [Value](value/_index.md) | 值系列、直接码、文本、数量、日期 |
| [Meta](meta/_index.md) | 结构、定义、出处、谱系、验证、策略、IMPORT |
| [Edge](edge/_index.md) | 陈述、依据、执行、TOULMIN 系列，TRIPLE、QUALIFIER、LABEL |
| [TOULMIN](toulmin/_index.md) | 判定与执行图系列，NODE、LINK、SOURCE 布局 |
| [示例：Wikidata 条目](example.md) | 按 WORD 逐个阅读一个文档 |

## 无需 Codec 手册即可知道的内容 {#코덱북-없이-알-수-있는-것}

| 信息 | 无 Codec 手册时 | 依据 |
|---|---|---|
| Kind | 可知 | TAG WORD 的章节 `w >> 9` 区间（Reference 0~2，Value 3·4，Edge 5~13，Meta 14·15） |
| 记录总长度、下一条记录的位置 | 可知 | TAG WORD 的 Length |
| Codec 编号 | 可知 | TAG WORD（Issuer 格式则为扩展 TAG 的 Issuer 与 Codec 编号） |
| 系列、类 | 部分可知 | 只有 Edge 直接码的系列可由比特得知。Value 直接码、Issuer 格式的系列以及 Meta 类无法由比特得知。Issuer 格式可知 Issuer 和 Codec 编号。Meta 验证类可由章节 15 的 `C >= 5`（`w >= 0x1E50`）得知 |
| Edge 的 Edge Id | 可知 | Edge（章节 5~13）的第一个成分始终是 LOCAL Reference |
| 占位标记（未填写·未知·无） | 可知 | WORD 值为 `0x0000`、`0x0010`、`0x0020`（Reference，C < 3，L 0）。见[占位标记](slot-marker.md) |
| Quantifier | 可知 | 由章节内偏移 `C` 得知：章节 0 中 `5 <= C < 30`，章节 1 中 `C < 30` 时为 `C % 5` |
| 各 Codec 的 TAG 长度、Payload 起始位置 | 不可知 | Codec 手册 |
| Payload 的解释、Edge 成分的角色 | 不可知 | Codec 手册 |

- 没有 Codec 手册的解码器可以跳过记录，并按 Kind 和 Codec 计数，但无法沿着图结构遍历。
- 所有解码器都必须处理 Meta 的结构、定义、IMPORT 类。这些 Codec 属于 GEUL 核心 Codec 手册，解码器通过内置编号表获知它们（[Meta](meta/_index.md)）。

Codec 手册以 GEUL 文档的形式公布（[Codec 规格文档](codec-spec.md)）。因此解码器只需获取并阅读所需的规格文档即可。

## 区域结构 {#영역-구조}

TAG WORD 的高位比特划分区域。

| Prefix | 区域 | 比例 | 定义 |
|---|---|---|---|
| `1` | 远期未来 | 50% | Reserved（远期未来）。不使用 |
| `01` | 未来 | 25% | Reserved（近期未来）。不使用 |
| `001` | 标准 | 12.5% | 正式采纳并运行的语法 |
| `000` | 自由·提案 | 12.5% | 当前语法。被采纳后布局保持不变，仅把 Prefix 改为 `001` |

当前语法全部位于 `000` 区域。本规范中所有 TAG WORD 均以 `000` 开头。

- v1 解码器拒绝 Prefix 不是 `000` 的 TAG WORD。其他区域由后续版本规定。
- `000` 区域是提案空间。目前不适用注册或保护。
