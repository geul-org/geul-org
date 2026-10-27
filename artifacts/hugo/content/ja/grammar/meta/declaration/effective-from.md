---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM は、このバージョンの施行日を日付・タイムスタンプ Value で宣言する定義 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

このバージョンの施行日を宣言する。施行日は公表時刻とは異なる([改訂](/ja/grammar/document/#改訂))。

## レイアウト

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length 拡張 TAG]
Payload           TIME Value 一つ
```

- Codec: Meta `0x13`、定義クラス(`001`)
- Payload: 組み込み Value([GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/) または [POSIX-TIMESTAMP-SECONDS](/ja/grammar/value/time/posix-timestamp-seconds/))
- 個数: 多くて一つ

## 解釈と有効性

- なければ公表時刻から施行する。
- [EFFECTIVE-UNTIL](/ja/grammar/meta/declaration/effective-until/) があれば、それより前でなければならない。
- 条文ごとに施行日が異なるなら、その条文 Edge に QUALIFIER P580(開始)・P582(終了)として別に書く([SOURCE](/ja/grammar/edge/source/#他の根拠の表現))。
- ドキュメントを特定の時点を基準に解釈するとき、この値を読む。

## 例

- 1970-01-02 施行: `0x1993 0x0920 0x0000 0x0001`
