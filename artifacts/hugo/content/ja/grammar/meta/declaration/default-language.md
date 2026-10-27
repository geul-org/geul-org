---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE は、ドキュメントのテキストの既定の言語を言語 Value で宣言する定義 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントのテキストの既定の言語を宣言する。言語を別に書かなかったテキストは、この言語だ。

## レイアウト

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length 拡張 TAG]
Payload           言語 Value 一つ
```

- Codec: Meta `0x16`、定義クラス(`001`)
- Payload: 組み込み Value([LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/) または [LANGUAGE-SHORT-CODE](/ja/grammar/value/text/language-short-code/))
- 個数: 多くて一つ

## 解釈と有効性

- TANGEUL ドキュメントは、作成ロケールを書く(例: `en`、`ko`)。

## 例

- `en`: `0x1916 0x08C6 0x656E`
