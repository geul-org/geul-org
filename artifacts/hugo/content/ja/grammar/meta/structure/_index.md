---
title: "Meta — 構造"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Meta 構造クラス(上位3ビット `000`、`0x00`~`0x0F`)は、ドキュメントの境界と長さを定める。DOC-1WORD/2WORD/4WORD で開き、BODY で HEAD を終え、END で閉じる。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 構造クラス(上位3ビット `000`、Codec `0x00`~`0x0F`)は、ドキュメントの境界と長さを定める。GEUL データの単位は、ドキュメント一つだ。

```
DOC-*                  ← HEAD の開始
  定義・出典・系譜・検証・ポリシー・IMPORT Meta
  ドキュメント全体の SOURCE とその QUALIFIER
BODY                   ← BODY の開始
  Reference, Value, Edge
END                    ← ドキュメントを閉じる
```

- すべてのドキュメントは、`DOC-1WORD/2WORD/4WORD` で全体の長さを指定して開く。デコーダは、この長さでドキュメント全体を一度に読み飛ばせる。
- `BODY` と `END` は、Payload のない 1 WORD レコードだ。`END` は必須だ。
- ドキュメントは入れ子にしない。他のドキュメントは IMPORT で指す。
- HEAD(Meta、ドキュメント全体の SOURCE とその QUALIFIER)が空なら、`BODY` を省略する。`BODY` はドキュメントごとに一度だけ置ける。

ドキュメント構造の全体は[ドキュメント](/ja/grammar/document/)にある。
