---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE は完全な BCP 47 language tag を ASCII バイト列として収める Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE は完全な BCP 47 language tag を ASCII バイト列として収める Value である。偶数·奇数バイトのコードの組 0x076L/0x077L を使う。

| 項目 | 値 |
|---|---|
| 名前 | `LANGUAGE-BCP47-CODE` (偶奇の組。コードごとの名前は下の構成員の表) |
| TAG ID | `0x076L`·`0x077L` |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 22~23 |
| Kind | Value · 系列: TEXT |
| 索引の説明 | canonical casing の完全な BCP 47 language tag の ASCII バイト列。偶数·奇数バイト |
| Hugo 側 | `value/text/language-bcp47-code.md` |

## 構成員 {#구성원}

このページは偶奇の組をなす二つのコードをまとめて扱う。偶数コードはバイト数が偶数、奇数コードは奇数の値である([レコードと TAG WORD](../record.md#가변-길이-바이트열))。Codec ドキュメントはコードごとに一つである。二つの Codec ドキュメントのフィールドは同じで、DECLARE の対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | バイト数 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | 偶数 | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | 奇数 | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 残り生値(`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE は完全な BCP 47 language tag を収める Value である。script、region、variant まで含めて言語を正確に記すときに使う。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x076L`(偶数バイト)·`0x077L`(奇数バイト)。系列 TEXT。
- バイト数は Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット`であり、Byte Count は置かない([Value](_index.md))。
- Payload は UTF-8 テキストではなく BCP 47 tag の ASCII バイト列である。

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## 解釈と有効性 {#해석과-유효성}

- バイト列は RFC 5646 の well-formed な BCP 47 language tag でなければならない。空文字列は許さない。
- Payload は ASCII 文字、数字、hyphen-minus `-` だけを使う。区切りは必ず ASCII `-` であり、`_`、空白、非 ASCII 文字は許さない。
- BCP 47 tag の比較は大文字小文字を区別しない。GEUL canonical profile は区切りをすべて `-` で書き、language/extlang/variant/extension/private-use の subtag は小文字、script は Titlecase、region は大文字でシリアライズする。
- well-formed だけでは十分でない。registered subtag と grandfathered tag の有効性は特定の IANA Language Subtag Registry snapshot を基準に判定し、その snapshot の日付や registry version を併せて保存しなければならない。
- private-use tag と private-use subtag は、RFC 5646 の文法で well-formed なら許す。ただしその意味は当事者の合意に依存し、IANA registry が定義しないので、公共の相互運用は保証されない。
- 同じ snapshot で deprecated subtag や grandfathered tag に Preferred-Value があれば、canonical GEUL form はその置換値を canonical casing で書く。deprecated 表記のままの tag は入力として解釈できても、canonical な保存形ではない。
- BCP 47 は ASCII profile なので、UTF-8 NFC のような Unicode normalization の要求は適用しない。
- WORD の中では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload WORD 数は `ceil(バイト数/2)` である。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準の根拠 {#표준-근거}

- language tag の文法、大文字小文字を区別しない解釈、deprecated/Preferred-Value の概念は [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646) に従う。
- tag の有効性を判定する registry は [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) である。
- 偶奇のコードの組、zero padding、canonical casing の保存ポリシーと Length の計算は GEUL の framing 規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`·`1111` の拡張長を使い、拡張 TAG も全体の数に含める([Length](../record.md))。

## LANGUAGE-SHORT-CODE との関係 {#language-short-code와의-관계}

- GEUL Language Registry に番号がある tag は [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) の 1 WORD で書ける。
- レジストリに番号がない tag(extension·private-use を含む tag も含む)は LANGUAGE-BCP47-CODE で書く。full tag の原文を保存する必要がある場合も LANGUAGE-BCP47-CODE を使う。
- SHORT-CODE `n` と、レジストリが `n` に結び付けた tag の LANGUAGE-BCP47-CODE(大文字小文字を無視)は同じ言語である。

## 例 {#예시}

- `ko-KR` は ASCII 5 byte(奇数)なので `LANGUAGE-BCP47-CODE-ODD`(`0x077L`)、Payload は `6B6F 2D4B 5200` である。
- TAG 1 WORD、Payload 3 WORD で全体 4 WORD、`LLLL=0011` である。全体は `0773 6B6F 2D4B 5200` である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000760/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

上は `LANGUAGE-BCP47-CODE-EVEN`(`0x076L`)の Codec ドキュメントである。他の構成員(`LANGUAGE-BCP47-CODE-ODD`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE の対象、`#1` に結び付けた名前(BIND)だけが異なる。
