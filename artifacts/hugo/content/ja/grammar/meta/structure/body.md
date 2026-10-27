---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY は、ドキュメントの HEAD を終えて BODY を始める 1 WORD の構造 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

HEAD を終えて BODY を始めるレコードだ。

## レイアウト

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length 拡張 TAG]
```

- Codec: Meta `0x0E`、構造クラス(`000`)
- Payload: なし(1 WORD)
- 個数: ドキュメントごとに多くて一つ

## 解釈と有効性

- HEAD が空なら省略する。`BODY` のないドキュメントは、すべて BODY だ。HEAD に Meta や HEAD Edge(ドキュメント全体の [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)とその QUALIFIER)があれば置く。
- Payload はない。全体で 1 WORD だ。

## 例

- `0x180E`
