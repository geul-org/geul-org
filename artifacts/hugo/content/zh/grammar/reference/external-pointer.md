---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER 是指向通过 HEAD 的 IMPORT-DOC 导入的文档的 LOCAL ID 的指示 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER 是指向通过 HEAD 的 [IMPORT-DOC](/zh/grammar/meta/import/import-doc/) 导入的文档的 LOCAL ID 的指示 Reference。

## 布局

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length 扩展 TAG]
IMPORT ID         由 WW 决定的宽度 (00=1, 01=2, 10=4, 11=8 WORD)
目标 ID           其余全部。被导入文档的 LOCAL ID，最短宽度
```

| CCCC | 名称 | IMPORT ID 宽度 |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- 使用能容纳 IMPORT ID 值的最窄 Codec。
- IMPORT ID 是本文档的 `IMPORT-DOC` 所分配的值，只在本文档内有效。EXTERNAL-POINTER 中不写 Issuer。Issuer 和文档 ID 从该 `IMPORT-DOC` 获得。版本也由该 `IMPORT-DOC` 决定（固定或最新）。
- 只要是被导入文档的同一个 LOCAL ID，无论在该文档内作为 LOCAL 使用，还是在这里作为 EXTERNAL-POINTER 使用，都是同一个目标。
- 如果是 Variable，则是被导入文档的 LOCAL 变量。

## 有效性

- 本文档中没有分配该 IMPORT ID 的 `IMPORT-DOC`，则 invalid。
- IMPORT ID 能放入更窄的 Codec 却使用了更宽的 Codec，则作为 non-minimal 拒绝。
- 目标 ID 为 `0` 则 invalid。被导入文档自身用 [DOC-POINTER](/zh/grammar/reference/doc-pointer/) 指向。
- 禁止目标 ID 带前导 `0x0000` WORD。

## 示例

| 目标 | WORD sequence |
|---|---|
| IMPORT ID 1 的 LOCAL 5 | `0140 0001 0005` |
| IMPORT ID 1 的 LOCAL 65536 | `01C0 0001 0001 0000` |
| IMPORT ID 70000 的 LOCAL 5 | `01C8 0001 1170 0005` |

## 相关页面

- [Reference](/zh/grammar/reference/)、[LOCAL](/zh/grammar/reference/local/)、[EXTERNAL-ISSUER](/zh/grammar/reference/external-issuer/)、[DOC-POINTER](/zh/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/zh/grammar/meta/import/import-doc/)
