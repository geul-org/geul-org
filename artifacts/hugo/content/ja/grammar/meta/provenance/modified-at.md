---
title: "MODIFIED-AT"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "MODIFIED-AT は、ドキュメントを修正した時刻を TIME Value で書く出典 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントを修正した時刻を書く。

## レイアウト

```
TAG WORD          0001 1LLL L010 0011      Codec 0x23
[Length 拡張 TAG]
Payload           TIME Value 一つ (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS など)
```

- Codec: Meta `0x23`、出典クラス(`010`)
- Payload: 組み込み Value(TIME 系列: [GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/)、[POSIX-TIMESTAMP-SECONDS](/ja/grammar/value/time/posix-timestamp-seconds/) など)
- 個数: 多くて一つ

## 解釈と有効性

- 形式は TIME 系列の Value から選ぶ。精度が必要なら、Issuer が定義したナノ秒形式(例: [POSIX-TIMESTAMP-NANOSECONDS](/ja/grammar/value/time/posix-timestamp-nanoseconds/))を使う。
