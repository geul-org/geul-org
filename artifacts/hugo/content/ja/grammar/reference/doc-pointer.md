---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER は、Issuer が公表したドキュメントの一バージョンを指す指示宣言 Reference だ。バージョン ID 0 は最新バージョンだ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER は、Issuer が公表したドキュメントの一バージョンを指す指示宣言 Reference だ。ドキュメントの公表・deprecate・削除、引用する版、ドキュメントについての記述の対象になる。

## レイアウト

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length 拡張 TAG]
Issuer            1/2/4/16 WORD
ドキュメント ID   4 WORD
バージョン ID     2 WORD
```

## 解釈と有効性

- Issuer の幅は、Payload からドキュメント ID とバージョン ID の 6 WORD を引いた残りだ。Codec は幅を分けない。幅が 1、2、4、16 WORD でなかったり、Issuer の値がより狭い幅に収まれば invalid だ(Issuer 正規形)。
- バージョン ID は省略しない。省略を許すと、Payload の長さだけでは Issuer の幅を決められない(Issuer 4 WORD・バージョンなしと、Issuer 2 WORD・バージョンありが、同じ 8 WORD になる)。
- バージョン ID `0` は最新バージョンだ。解釈する時点の現行バージョンに結びつく。それ以外の値は、そのバージョンに固定される([PUBLICATION](/ja/grammar/edge/publication/))。
- ドキュメント ID `0` は、Issuer の用語定義インデックスドキュメントだ。Issuer 自身は [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) で指す。
- Quantifier は `000`(Identified)だけを使う。他の値は invalid だ。
- Issuer のドキュメントを指す形式は DOC-POINTER 一つだ。`EXTERNAL-ISSUER-*`(Issuer、ドキュメント ID、対象 ID `0`)や `EXTERNAL-POINTER-*`(IMPORT ID、対象 ID `0`)でドキュメントを指すことは invalid だ。
- 使う場所: Meta [DOC-ID](/ja/grammar/meta/declaration/doc-id/)・[IMPORT-DOC](/ja/grammar/meta/import/import-doc/)、バージョン一覧の PUBLICATION・DEPRECATION・TOMBSTONE と BIND の Subject、名前索引 `documents.geul` の BIND の Subject。

## 例

GEUL Issuer `0x0000` のドキュメント `0xffff000000000001`。

| バージョン | WORD sequence |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| 最新 (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + ドキュメント ID 4 + バージョン ID 2 = 8 WORD、`LLLL=0111` だ。TAG は `0000 0 0111 0111 000` = `03B8` だ。

## 関連ページ

- [Reference](/ja/grammar/reference/)、[ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/)、[EXTERNAL-ISSUER](/ja/grammar/reference/external-issuer/)、[PUBLICATION](/ja/grammar/edge/publication/)
- [Issuer と公表](/ja/grammar/issuer/)
