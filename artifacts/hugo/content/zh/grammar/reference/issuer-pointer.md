---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER 是指向 Issuer 自身的指示声明 Reference。Payload 只有一个 Issuer。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER 是指向 Issuer 自身的指示声明 Reference。它是 Issuer 名称 `BIND`、`LABEL`、判定 Edge 的对象。

## 布局

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length 扩展 TAG]
Issuer            1/2/4/16 WORD
```

- Issuer 宽度就是整个 Payload。Codec 不划分宽度。宽度不是 1、2、4、16 WORD，或 Issuer 的值能放入更窄的宽度，则 invalid（Issuer 规范形式）。
- Issuer 为 16 WORD 时总共是 17 WORD，所以要加上 1 WORD 的 Length 扩展。
- Quantifier 只使用 `000`（Identified）。其他值 invalid。
- Issuer 值遵循 [Issuer](/zh/grammar/issuer/) 的分配。
- 用途：Issuer 名称索引 `issuers.geul` 的 BIND Subject（[公布地址与版本列表](/zh/grammar/publishing/#issuer-名称)）、Issuer 显示名称 LABEL、对 Issuer 的判定、签名者等以 Issuer 自身为对象的位置。
- 指向 Issuer 自身的格式只有 ISSUER-POINTER 一种。用 `EXTERNAL-ISSUER-*` 写文档 ID `0`、目标 ID `0` 来指向 Issuer 则 invalid。

## 示例

| Issuer | WORD sequence |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## 相关页面

- [Reference](/zh/grammar/reference/)、[DOC-POINTER](/zh/grammar/reference/doc-pointer/)、[EXTERNAL-ISSUER](/zh/grammar/reference/external-issuer/)、[Issuer 与公布](/zh/grammar/issuer/)
