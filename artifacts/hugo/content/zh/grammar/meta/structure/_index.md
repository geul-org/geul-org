---
title: "Meta — 结构"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Meta 结构类（高 3 位 `000`，`0x00`~`0x0F`）规定文档的边界与长度。以 DOC-1WORD/2WORD/4WORD 开启，以 BODY 结束 HEAD，以 END 关闭。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 结构类（高 3 位 `000`，Codec `0x00`~`0x0F`）规定文档的边界与长度。GEUL 数据的单位是一个文档。

```
DOC-*                  ← HEAD 开始
  定义·出处·谱系·验证·策略·IMPORT Meta
  整个文档的 SOURCE 及其 QUALIFIER
BODY                   ← BODY 开始
  Reference, Value, Edge
END                    ← 关闭文档
```

- 每个文档都以 `DOC-1WORD/2WORD/4WORD` 指定总长度来开启。解码器可凭此长度一次跳过整个文档。
- `BODY` 和 `END` 是没有 Payload 的 1 WORD 记录。`END` 必须有。
- 文档不嵌套。其他文档通过 IMPORT 指向。
- HEAD（Meta、整个文档的 SOURCE 及其 QUALIFIER）为空时可省略 `BODY`。每个文档至多有一个 `BODY`。

文档结构的完整说明见[文档](/zh/grammar/document/)。
