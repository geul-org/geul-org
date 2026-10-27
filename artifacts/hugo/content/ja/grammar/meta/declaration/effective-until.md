---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL は、このバージョンの有効期間の終わり(限時法)を日付・タイムスタンプ Value で宣言する定義 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

このバージョンの有効期間の終わりを宣言する(限時法)。その時刻から、このバージョンは施行中ではない。

## レイアウト

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length 拡張 TAG]
Payload           TIME Value 一つ
```

- Codec: Meta `0x14`、定義クラス(`001`)
- Payload: 組み込み Value([GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/) または [POSIX-TIMESTAMP-SECONDS](/ja/grammar/value/time/posix-timestamp-seconds/))
- 個数: 多くて一つ

## 解釈と有効性

- なければ、次のバージョンが施行されるまで有効だ。
- 有効期間が過ぎると、施行中の版はない。古い版が復活することはない。
