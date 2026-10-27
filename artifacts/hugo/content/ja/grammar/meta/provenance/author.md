---
title: "AUTHOR"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "AUTHOR は、ドキュメントの内容を書いた主体を Reference で書く出典 Meta だ(git author)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントの内容を書いた主体を書く(git author)。

## レイアウト

```
TAG WORD          0001 1LLL L010 0000      Codec 0x20
[Length 拡張 TAG]
Payload           Reference レコード一つ (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL など)
```

- Codec: Meta `0x20`、出典クラス(`010`)
- Payload: 組み込み Reference
- 個数: 多くて一つ

## 解釈と有効性

- Reference は Codec を問わない。人・組織・モデル・ルールエンジンのいずれでもよい([EXTERNAL-ISSUER](/ja/grammar/reference/external-issuer/)、[GEUL](/ja/grammar/reference/geul/)、[WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/)、[LOCAL](/ja/grammar/reference/local/) など)。
- geul.org の公表ドキュメントには、自然人を指す Reference を置かない([Issuer と公表](/ja/grammar/issuer/#geulorg-公表))。組織・Issuer を指す。例外として [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/) で自然人を指すことは許容する。
- LOCAL なら、BODY でその対象を記述する。
