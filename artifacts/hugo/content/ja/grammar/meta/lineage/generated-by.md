---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY は、ドキュメントを作った主体(人、モデル、ルールエンジン)とそのバージョンを書く系譜 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントを作った主体を書く。人、モデル、ルールエンジンのいずれでもよい。

## レイアウト

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length 拡張 TAG]
生成主体          Reference (人、モデル、ルールエンジン)
バージョン        UTF8-TEXT Value、または省略マーカー 0x0000 (オプションフィールド)
```

- Codec: Meta `0x32`、系譜クラス(`011`)
- Payload: 組み込み Reference + バージョンテキスト(任意)
- 個数: 複数可

## 解釈と有効性

- モデルなら、モデルのバージョンも併せて書く。
- バージョンが分からない、または置かないなら、その位置を省略して ABSENT(`0x0000`)を書く([CODEC](/ja/grammar/edge/codec/) のオプションフィールド)。geul.org 規格 `0x1832` は、agent(CODEC なし)と version(`0840`・`0841`・`0000`)の二つのレコードフィールドだ。
- プログラムのソースバージョン(コミット)は、[TRANSFORMED-BY](/ja/grammar/meta/lineage/transformed-by/) の形式(ダイジェスト、必須)のほうが正確だ。GENERATED-BY のバージョンは、モデル名・バージョンのように、コミット ID ではないものをテキストで書く。
- geul.org の公表ドキュメントには、自然人を指す Reference を置かない([Issuer と公表](/ja/grammar/issuer/#geulorg-公表))。組織・Issuer を指す。例外として [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/) で自然人を指すことは許容する。
