---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER は、Issuer が公表したドキュメントの LOCAL ID を、IMPORT なしでレコード一つで引用する指示宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER は、Issuer が公表したドキュメントの LOCAL ID を、IMPORT なしで引用する指示宣言 Reference だ。レコード一つで意味が完結し、最新バージョンに従う。

## レイアウト

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length 拡張 TAG]
Issuer            WW が定めた幅 (00=1, 01=2, 10=4, 11=16 WORD)
ドキュメント ID   4 WORD
対象 ID           残りすべて。そのドキュメントの LOCAL ID、最短幅
```

| CCCC | 名前 | Issuer の幅 |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (geul.org が割り当て) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (geul.org に登録、ドメイン証明) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (geul.org に登録、証明なし) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (公開鍵から計算) |

- Issuer ID は整数値だ。値が同じなら同じ Issuer だ。Issuer は、値が収まる最短幅で書き、その幅の Codec を選ぶ(値が `0xFFFF` を超えるときだけ 2 WORD、`2^32` 以上のときだけ 4 WORD、`2^64` 以上のときだけ 16 WORD)。より広い幅の表記は invalid だ([Issuer](/ja/grammar/issuer/))。
- Issuer の登録と管理は geul.org が担う。
- バージョンは書かず、最新バージョンに従う。バージョンを固定するには、[IMPORT-DOC](/ja/grammar/meta/import/import-doc/) と [EXTERNAL-POINTER](/ja/grammar/reference/external-pointer/) を使う。
- 位置は、公表アドレスの規則で探す([公表アドレスとバージョン一覧](/ja/grammar/publishing/))。
- そのドキュメントの同じ LOCAL ID なら、そのドキュメントの中で LOCAL として使っても、他のドキュメントで EXTERNAL-ISSUER として使っても(または IMPORT の後で EXTERNAL-POINTER として使っても)、同じ対象だ。
- ドキュメントの LOCAL だけを指す。ドキュメント自身は [DOC-POINTER](/ja/grammar/reference/doc-pointer/)、Issuer 自身は [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) で指す。そのため対象 ID は `0` ではない。ドキュメント ID `0` は、Issuer の用語定義インデックスドキュメントだ。

## 有効性

- Issuer の幅が Codec と合わなかったり、値がより狭い幅に収まれば invalid だ。
- 対象 ID が `0` なら invalid だ。対象 ID `0`(ドキュメント自身)は DOC-POINTER が担う。
- 対象 ID の先頭の `0x0000` WORD は禁止する。

## 例

| 対象 | WORD sequence |
|---|---|
| Issuer `0x0001`、ドキュメント `0x…0002`、LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`、ドキュメント `0x…0002`、LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## 関連ページ

- [Reference](/ja/grammar/reference/)、[DOC-POINTER](/ja/grammar/reference/doc-pointer/)、[ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/)、[EXTERNAL-POINTER](/ja/grammar/reference/external-pointer/)
- [Issuer と公表](/ja/grammar/issuer/)
