---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER は、HEAD の IMPORT-DOC で取り込んだドキュメントの LOCAL ID を指す指示 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER は、HEAD の [IMPORT-DOC](/ja/grammar/meta/import/import-doc/) で取り込んだドキュメントの LOCAL ID を指す指示 Reference だ。

## レイアウト

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length 拡張 TAG]
IMPORT ID         WW が定めた幅 (00=1, 01=2, 10=4, 11=8 WORD)
対象 ID           残りすべて。取り込んだドキュメントの LOCAL ID、最短幅
```

| CCCC | 名前 | IMPORT ID の幅 |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- IMPORT ID の値が収まる最も狭い Codec を使う。
- IMPORT ID は、このドキュメントの `IMPORT-DOC` が割り当てた値で、このドキュメント内でのみ有効だ。EXTERNAL-POINTER には Issuer を書かない。Issuer とドキュメント ID は、その `IMPORT-DOC` から得る。バージョンも、その `IMPORT-DOC` が決める(固定または最新)。
- 取り込んだドキュメントの同じ LOCAL ID なら、そのドキュメントの中で LOCAL として使っても、ここで EXTERNAL-POINTER として使っても、同じ対象だ。
- Variable なら、取り込んだドキュメントの LOCAL 変数だ。

## 有効性

- このドキュメントに、その IMPORT ID を割り当てた `IMPORT-DOC` がなければ invalid だ。
- IMPORT ID がより狭い Codec に収まるのに広い Codec を使えば、non-minimal として拒否する。
- 対象 ID が `0` なら invalid だ。取り込んだドキュメント自身は [DOC-POINTER](/ja/grammar/reference/doc-pointer/) で指す。
- 対象 ID の先頭の `0x0000` WORD は禁止する。

## 例

| 対象 | WORD sequence |
|---|---|
| IMPORT ID 1 の LOCAL 5 | `0140 0001 0005` |
| IMPORT ID 1 の LOCAL 65536 | `01C0 0001 0001 0000` |
| IMPORT ID 70000 の LOCAL 5 | `01C8 0001 1170 0005` |

## 関連ページ

- [Reference](/ja/grammar/reference/)、[LOCAL](/ja/grammar/reference/local/)、[EXTERNAL-ISSUER](/ja/grammar/reference/external-issuer/)、[DOC-POINTER](/ja/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/ja/grammar/meta/import/import-doc/)
