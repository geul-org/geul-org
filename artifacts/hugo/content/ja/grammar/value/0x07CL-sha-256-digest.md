---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST は SHA-2 系列の SHA-256 の結果全体を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SHA-256-DIGEST` (規格ドキュメント BIND `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| 規格ドキュメント | `0x00000000/codecs/0x000007C0/` (DECLARE の対象 `07C0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 28 |
| Kind | Value · 系列: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 固定 Payload 16 WORD の SHA-256 の結果 |
| Hugo 側 | `value/binary/sha-256-digest.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 生値 16 WORD |  |  |

SHA-256-DIGEST は SHA-2 系列の SHA-256 の結果全体を収める固定幅の Value である。Value 直接コード `0x07CL`、系列 BINARY である。Payload はちょうど 16 WORD(256 bit)で、切り詰め(truncation)は許さない。

## レイアウト {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0012 (全体 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## 解釈と有効性 {#해석과-유효성}

- Payload の 32 octet を SHA-256 の出力順のまま読む。各 WORD では上位 octet が先に来る。
- digest の bit string に GEUL の endian 変換を別途適用しない。出力 octet sequence を順に二つの octet ずつ組にして、16bit big-endian WORD として framing するだけである。
- Payload が 16 WORD でない表現や、結果を任意に切り詰めた表現は拒否する。descriptor と padding はない。

## 標準の根拠 {#표준-근거}

- SHA-256 アルゴリズムと 256bit の結果は NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) に従う。
- GEUL の TAG、Length、16bit WORD framing はこの形式が加える規則であり、SHA-2 アルゴリズムの一部ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG 1 WORD、Payload 16 WORD を合わせたちょうど 18 WORD で、`LLLL=1110` を使う。descriptor と padding はない。
- Payload がちょうど 16 WORD でなければ拒否する。

## 例 {#예시}

- digest octet `d[0]` から `d[31]` までは、Payload WORD `(d[0]<<8)|d[1]` から `(d[30]<<8)|d[31]` まで順に置く。全体の Length は常に 18 WORD である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000007C0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
