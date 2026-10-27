---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER は Issuer 自身を指す指示宣言 Reference だ。Payload は Issuer 一つだけだ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER は、Issuer 自身を指す指示宣言 Reference だ。Issuer 名の `BIND`、`LABEL`、判定 Edge の対象になる。

## レイアウト

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length 拡張 TAG]
Issuer            1/2/4/16 WORD
```

- Issuer の幅は Payload 全体だ。Codec は幅を分けない。幅が 1、2、4、16 WORD でなかったり、Issuer の値がより狭い幅に収まれば invalid だ(Issuer 正規形)。
- Issuer が 16 WORD なら全体で 17 WORD になるので、Length 拡張 1 WORD が付く。
- Quantifier は `000`(Identified)だけを使う。他の値は invalid だ。
- Issuer の値は、[Issuer](/ja/grammar/issuer/) の割り当てに従う。
- 用途: Issuer 名前索引 `issuers.geul` の BIND の Subject([公表アドレスとバージョン一覧](/ja/grammar/publishing/#issuer-名))、Issuer の表示名 LABEL、Issuer についての判定、署名者など、Issuer 自身が対象となる位置。
- Issuer 自身を指す形式は ISSUER-POINTER 一つだ。`EXTERNAL-ISSUER-*` でドキュメント ID `0`、対象 ID `0` を使って Issuer を指すことは invalid だ。

## 例

| Issuer | WORD sequence |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## 関連ページ

- [Reference](/ja/grammar/reference/)、[DOC-POINTER](/ja/grammar/reference/doc-pointer/)、[EXTERNAL-ISSUER](/ja/grammar/reference/external-issuer/)、[Issuer と公表](/ja/grammar/issuer/)
