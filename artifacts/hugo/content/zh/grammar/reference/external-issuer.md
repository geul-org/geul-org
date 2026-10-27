---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER 是无需 IMPORT、用一条记录引用 Issuer 公布的文档的 LOCAL ID 的指示声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER 是无需 IMPORT 即可引用 Issuer 公布的文档的 LOCAL ID 的指示声明 Reference。一条记录含义完整，并跟随最新版本。

## 布局

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length 扩展 TAG]
Issuer            由 WW 决定的宽度 (00=1, 01=2, 10=4, 11=16 WORD)
文档 ID           4 WORD
目标 ID           其余全部。该文档的 LOCAL ID，最短宽度
```

| CCCC | 名称 | Issuer 宽度 |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD（geul.org 分配） |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD（geul.org 注册，域名证明） |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD（geul.org 注册，无证明） |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD（由公钥计算） |

- Issuer ID 是整数值。值相同即为同一个 Issuer。Issuer 用能容纳该值的最短宽度书写，并选择该宽度的 Codec（值超过 `0xFFFF` 才用 2 WORD，达到 `2^32` 以上才用 4 WORD，达到 `2^64` 以上才用 16 WORD）。更宽宽度的写法 invalid（[Issuer](/zh/grammar/issuer/)）。
- Issuer 的注册和管理由 geul.org 负责。
- 不写版本，跟随最新版本。要固定版本，使用 [IMPORT-DOC](/zh/grammar/meta/import/import-doc/) 和 [EXTERNAL-POINTER](/zh/grammar/reference/external-pointer/)。
- 位置按公布地址规则查找（[公布地址与版本列表](/zh/grammar/publishing/)）。
- 只要是该文档的同一个 LOCAL ID，无论是在该文档内作为 LOCAL 使用，还是在其他文档中作为 EXTERNAL-ISSUER 使用（或 IMPORT 之后作为 EXTERNAL-POINTER 使用），都是同一个目标。
- 只指向文档的 LOCAL。文档自身用 [DOC-POINTER](/zh/grammar/reference/doc-pointer/)，Issuer 自身用 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) 指向。因此目标 ID 不是 `0`。文档 ID `0` 是 Issuer 的术语定义索引文档。

## 有效性

- Issuer 宽度与 Codec 不符，或值能放入更窄的宽度，则 invalid。
- 目标 ID 为 `0` 则 invalid。目标 ID `0`（文档自身）由 DOC-POINTER 负责。
- 禁止目标 ID 带前导 `0x0000` WORD。

## 示例

| 目标 | WORD sequence |
|---|---|
| Issuer `0x0001`、文档 `0x…0002`、LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`、文档 `0x…0002`、LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## 相关页面

- [Reference](/zh/grammar/reference/)、[DOC-POINTER](/zh/grammar/reference/doc-pointer/)、[ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/)、[EXTERNAL-POINTER](/zh/grammar/reference/external-pointer/)
- [Issuer 与公布](/zh/grammar/issuer/)
