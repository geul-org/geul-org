---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST は、SHA-1 の結果 160bit 全体を収める固定 11 WORD の Value で、git オブジェクト ID のような識別用途にのみ使う。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST は、SHA-1 の結果全体を収める固定幅の Value だ。Value 直接コード `0x62`、系列 BINARY だ。Payload はちょうど 10 WORD(160 bit)で、切り詰め(truncation)は許さない。

**識別用途にのみ使う。** SHA-1 は衝突耐性が破られた(2017 SHAttered)。完全性・署名の根拠には [SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/) を使う。この形式は、すでに SHA-1 で決まった識別子、代表的には SHA-1 の git リポジトリのオブジェクト ID(コミット ID)を、そのまま収めるために置く。たとえば [TRANSFORMED-BY](/ja/grammar/meta/lineage/transformed-by/) の Version(コミット ID)を、hex テキスト(22 WORD)の代わりに 11 WORD で収める。

## レイアウト

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## 解釈と有効性

- Payload の 20 octet を SHA-1 の出力順のまま読む。各 WORD では上位 octet が先に来る(SHA-256-DIGEST と同じ framing)。
- Payload が 10 WORD でなかったり、結果を勝手に切り取った表現(git の省略 ID など)は拒否する。descriptor と padding はない。
- git オブジェクト ID は、git が計算した値そのままだ。git の SHA-1 は衝突検出を入れた変種(SHA-1DC)だが、衝突攻撃でない入力では結果が SHA-1 と同じだ。

## 標準の根拠

- SHA-1 アルゴリズムと 160bit の結果は、NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) に従う。
- GEUL TAG と 16bit WORD framing は、この形式が加える規則だ。

## 長さ

- 全体は、TAG 1 WORD と Payload 10 WORD を合わせたちょうど 11 WORD で、`LLLL=1010` を使う。Length 拡張はない。

## 例

git コミット `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## 関連ページ

- [Value](/ja/grammar/value/)、[SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/)、[TRANSFORMED-BY](/ja/grammar/meta/lineage/transformed-by/)
