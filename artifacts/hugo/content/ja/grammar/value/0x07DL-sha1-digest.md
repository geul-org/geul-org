---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST は SHA-1 の結果全体を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SHA1-DIGEST` (規格ドキュメント BIND `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| 規格ドキュメント | `0x00000000/codecs/0x000007D0/` (DECLARE の対象 `07D0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 29 |
| Kind | Value · 系列: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 固定 Payload 10 WORD の SHA-1 の結果。git オブジェクト ID のような識別用途に限る |
| Hugo 側 | `value/binary/sha1-digest.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 生値 10 WORD |  |  |

SHA1-DIGEST は SHA-1 の結果全体を収める固定幅の Value である。Value 直接コード `0x07DL`、系列 BINARY である。Payload はちょうど 10 WORD(160 bit)で、切り詰め(truncation)は許さない。

**識別用途に限って使う。** SHA-1 は衝突耐性が破られた(2017 SHAttered)。完全性·署名の根拠には [SHA-256-DIGEST](0x07CL-sha-256-digest.md) を使う。この形式は、すでに SHA-1 で定まっている識別子、代表的には SHA-1 の git リポジトリのオブジェクト ID(コミット ID)をそのまま収めるために置く。たとえば [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) の Version(コミット ID)を hex テキスト(22 WORD)ではなく 11 WORD で収める。

## レイアウト {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## 解釈と有効性 {#해석과-유효성}

- Payload の 20 octet を SHA-1 の出力順のまま読む。各 WORD では上位 octet が先に来る(SHA-256-DIGEST と同じ framing)。
- Payload が 10 WORD でない表現や、結果を任意に切り詰めた表現(git の短縮 ID など)は拒否する。descriptor と padding はない。
- git オブジェクト ID は git が計算した値そのままである。git の SHA-1 は衝突検出を加えた変種(SHA-1DC)だが、衝突攻撃でない入力では結果が SHA-1 と同じである。

## 標準の根拠 {#표준-근거}

- SHA-1 アルゴリズムと 160bit の結果は NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) に従う。
- GEUL の TAG と 16bit WORD framing はこの形式が加える規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 10 WORD を合わせたちょうど 11 WORD で、`LLLL=1010` を使う。Length 拡張はない。

## 例 {#예시}

git コミット `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## 関連ページ {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000007D0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
