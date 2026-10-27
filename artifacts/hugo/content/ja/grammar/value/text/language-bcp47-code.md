---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE は、完全な BCP 47 language tag を ASCII バイト列で収める Value だ。偶数・奇数バイトのコードペア 0x46/0x47 を使う。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE は、完全な BCP 47 language tag を収める Value だ。script、region、variant まで言語を正確に書くときに使う。

## レイアウト

- コード: Value 直接コード `0x46`(偶数バイト)・`0x47`(奇数バイト)。系列 TEXT。
- バイト数は、Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` で、Byte Count は置かない([Value](/ja/grammar/value/))。
- Payload は UTF-8 テキストではなく、BCP 47 tag の ASCII バイト列だ。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## 解釈と有効性

- バイト列は、RFC 5646 の well-formed な BCP 47 language tag でなければならない。空文字列は許さない。
- Payload は ASCII の文字、数字、hyphen-minus `-` だけを使う。区切りは必ず ASCII の `-` で、`_`、空白、非 ASCII 文字は許さない。
- BCP 47 tag の比較は大文字小文字を区別しない。GEUL canonical profile は、区切りをすべて `-` で書き、language/extlang/variant/extension/private-use の subtag は小文字、script は Titlecase、region は大文字でシリアライズする。
- well-formed だけでは十分ではない。registered subtag と grandfathered tag の有効性は、特定の IANA Language Subtag Registry snapshot を基準に判定し、その snapshot の日付か registry version も併せて保存しなければならない。
- private-use tag と private-use subtag は、RFC 5646 の文法で well-formed なら許す。ただしその意味は当事者の合意次第で、IANA registry が定義しないので、公共の相互運用性は保証しない。
- 同じ snapshot で deprecated subtag や grandfathered tag に Preferred-Value があれば、canonical GEUL form はその置換値を canonical casing で書く。deprecated 表記のままの tag は、入力として解釈はできても canonical な保存形ではない。
- BCP 47 は ASCII profile なので、UTF-8 NFC のような Unicode 正規化の要求は適用しない。
- WORD の中では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload WORD 数は `ceil(バイト数/2)` だ。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準の根拠

- language tag の文法、大文字小文字を区別しない解釈、deprecated/Preferred-Value の概念は、[RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646) に従う。
- tag の有効性を判定する registry は、[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) だ。
- 偶奇コードのペア、zero padding、canonical casing の保存ポリシー、Length の計算は、GEUL の framing 規則だ。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に含める([Length](/ja/grammar/record/))。

## LANGUAGE-SHORT-CODE との関係

- primary language subtag だけを短く収めるには、[LANGUAGE-SHORT-CODE](/ja/grammar/value/text/language-short-code/) を使う。
- script、region、variant、extension、private-use が必要なら、LANGUAGE-BCP47-CODE を使う。
- LANGUAGE-SHORT-CODE registry にまだ割り当てられていない言語、`0xffff` escape が必要な場合、full tag の原文保存が必要な場合も、LANGUAGE-BCP47-CODE を使う。

## 例

- `ko-KR` は ASCII 5 byte(奇数)なので `LANGUAGE-BCP47-CODE-ODD`(`0x47`)、Payload は `6b6f 2d4b 5200` だ。
- TAG 1 WORD、Payload 3 WORD で全体 4 WORD、`LLLL=0011` だ。全体は `09C7 6b6f 2d4b 5200` だ。
