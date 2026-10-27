---
title: "概述"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 是由 16 位 WORD 构成的记录序列。记录有 Reference、Value、Edge、Meta 四种，记录们放在一个文档中。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL（General Encoding Unified Language）是供人和 AI 无歧义地交换信息的人工语言，也是一种二进制格式。本文定义 GEUL v1 的语法。

## 一览

- 所有数据都是 **16 位 WORD** 的序列，按大端序书写。
- 数据的单位是**记录**。记录以一个 TAG WORD 开头，由这个 TAG WORD 说明记录的种类和长度。
- 记录有四种（**Kind**）。

| Kind | 作用 | 例 |
|---|---|---|
| Reference | 指向目标 | Wikidata Q42、本文档内的 #7 |
| Value | 承载值本身 | 日期、数量、带语言的文本 |
| Edge | 把其他记录组合起来叙述 | "Q42 是人"、"Q42 的英文名是 Douglas Adams" |
| Meta | 谈论文档本身 | 规范版次、文档 ID、作者、签名 |

- 记录们放在一个**文档**中。文档像 HTML 一样分为 HEAD（Meta，以及整个文档的来源 SOURCE 及其 QUALIFIER）和 BODY（Reference·Value·Edge）。
- 文档由 **Issuer**（签发主体）发布，每个版本都用内容哈希固定。已公布的版本不再改动。

## 设计原则

1. **无需 codebook 即可跳过。** 记录的种类和长度在 TAG WORD 的 16 位里。不知道解读方法（codebook）的解码器也能数出记录并跳过。
2. **承载的是叙述，而不是事实。** 文档用 Meta 和依据 Edge 一并写明这是谁、何时、从什么而来的叙述。
3. **识别靠 Reference。** 用 ID 而不是名称来指向。名称用 Edge 附上。
4. **已公布的不再改动。** 修改的内容以新版本发布。文档内的 ID 跨版本指向同一目标。
5. **留白。** 把位空间的大部分留给未来。直接码无法收回，所以只分配已确认使用频率的格式。

## 领域结构

TAG WORD 的高位划分领域。

| Prefix | 领域 | 比例 | 定义 |
|---|---|---|---|
| `1` | 远未来 | 50% | 为远未来保留。不使用 |
| `01` | 未来 | 25% | 为近未来保留。不使用 |
| `001` | 标准 | 12.5% | 正式采纳并运行的语法 |
| `000` | 自由·提案 | 12.5% | 当前语法。被采纳后布局保持不变，只把 Prefix 移到 `001` |

当前语法全部在 `000` 领域。本规范的所有 TAG WORD 都以 `000` 开头。

- v1 解码器拒绝 Prefix 不是 `000` 的 TAG WORD。其他领域由后续版次决定。
- `000` 领域是提案空间。目前不适用登记或保护。不过 Issuer 格式布局是以正式标准发布后的登记体系为前提而保留的。

## 无需 codebook 就能知道的内容

| 信息 | 无 codebook 时 | 依据 |
|---|---|---|
| Kind | 知道 | TAG WORD |
| 记录总长度、下一条记录的位置 | 知道 | TAG WORD 的 Length |
| Codec 编号 | 知道 | TAG WORD（Issuer 格式则为扩展 TAG 的 Issuer 与格式编号） |
| 系列·类 | 知道 | Codec 编号或格式编号的高位 |
| Edge 的 Edge Id | 知道 | Edge 的第一个构成要素总是 LOCAL Reference |
| 占位标记（未写·未知·无） | 知道 | WORD 值为 `0`~`7`（Reference Codec `0000`，1 WORD）。[占位标记](/zh/grammar/reference/slot-marker/) |
| 各 Codec 的 TAG 长度、Payload 起始位置 | 不知道 | codebook |
| Payload 解读、Edge 构成要素的角色 | 不知道 | codebook |

- 没有 codebook 的解码器可以边跳过记录边按 Kind 和 Codec 计数，但无法沿着图结构走。
- 所有解码器都必须处理 Meta 的结构·定义·IMPORT 类。这些 Codec 属于 GEUL 核心 codebook（[Meta](/zh/grammar/meta/)）。

codebook 以 GEUL 文档的形式公布（[Codec 规格文档](/zh/grammar/codec-spec/)）。因此解码器只要获取并阅读所需的规格文档即可。

## 子文档

| 文档 | 内容 |
|---|---|
| [记录与 TAG WORD](/zh/grammar/record/) | TAG WORD 布局、Length、Codec、扩展 TAG |
| [文档](/zh/grammar/document/) | DOC·HEAD·BODY·END、文档 ID、内容哈希、版本与修订 |
| [Reference](/zh/grammar/reference/) | 目标识别、LOCAL、外部引用、Quantifier、占位标记 |
| [Value](/zh/grammar/value/) | 值系列、直接码、文本·数量·日期 |
| [Edge](/zh/grammar/edge/) | 叙述·依据·执行·TOULMIN 系列，TRIPLE·QUALIFIER·LABEL |
| [Meta](/zh/grammar/meta/) | 结构·定义·出处·谱系·验证·策略·IMPORT |
| [Issuer 与公布](/zh/grammar/issuer/) | Issuer 等级、1 WORD 分配表、公开方式、签名、验证密钥 |
| [公布地址与版本列表](/zh/grammar/publishing/) | ID 写法、公布地址、格式指定、名称索引、版本列表、信任层 |
| [Codec 规格文档](/zh/grammar/codec-spec/) | 用 DECLARE·FIELD·ENUM·CODEC 书写的 codebook |
| [示例：Wikidata 条目](/zh/grammar/example/) | 逐 WORD 阅读一个文档 |

## 未决问题

- 边界情形的 Kind。如关于陈述的陈述，在 Reference·Value·Edge·Meta 中归属哪一种存在分歧的情况。
