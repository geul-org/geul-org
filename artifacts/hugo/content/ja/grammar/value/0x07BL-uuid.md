---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID は RFC 9562 UUID の 128bit 値を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `UUID` (規格ドキュメント BIND `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| 規格ドキュメント | `0x00000000/codecs/0x000007B0/` (DECLARE の対象 `07B0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 27 |
| Kind | Value · 系列: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 固定 Payload 8 WORD の RFC 9562 UUID 128bit |
| Hugo 側 | `value/binary/uuid.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | 生値 8 WORD |  |  |

UUID は RFC 9562 UUID の 128bit 値を収める固定幅の Value である。Value 直接コード `0x07BL`、系列 BINARY である。Payload はちょうど 8 WORD(16 octet、128bit)である。

## レイアウト {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  全体 9 WORD
Payload           8 WORD (128ビット)  UUID octet 0 → octet 15
```

## 解釈と有効性 {#해석과-유효성}

- RFC 9562 の canonical UUID の octet 0 から octet 15 までを順に二つの octet ずつ組にする。先に来る octet が WORD の上位 8bit である。UUID の field、version bit、variant bit を並べ替えたり再 encode したりしない。
- `8-4-4-4-12` の hex-and-dash 文字列は入出力の表現にすぎない。大文字小文字やダッシュは Payload に入らず、パース結果の 16 octet だけを保存する。
- この UUID Value は 128bit pattern を損失なく保存する。RFC 9562 variant `10xx` では、version 1, 3, 4, 5, 6, 7 が標準 layout で、version 8 は custom UUID format である。version 2 は DCE Security 用に予約されていて RFC が layout を定めず、version 0 は unused、version 9–15 は将来の定義用に予約されている。他の variant も互換または将来の定義用に予約されている。
- Nil UUID は 128bit がすべて 0、Max UUID は 128bit がすべて 1 の特殊値である。予約済み·unused の version/variant を含む 128bit pattern も構造上は排除せず、その pattern の意味と相互運用性は、適用される標準と外部の文脈で判断する。
- UUID の同一性は、Payload の 128bit 値が等しいかどうかで判断する。同じ値であるという事実は、対象の認証、所有権、現在の存在、解決可能性、アクセス権限を保証しない。
- Microsoft COM GUID を保存するとき、mixed-endian のメモリ·シリアライズ表現をそのままコピーしない。先に RFC 9562 canonical の field/octet 順の 16 octet に変換する。
- Payload がちょうど 8 WORD でなければ拒否する。

## 標準の根拠 {#표준-근거}

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) は UUID を 16 octet(128bit)と定義し、field を most-significant-byte-first で encode して、binary format では big-endian の field 順につなぐ。variant は octet 8 の上位 bit、version は octet 6 の上位 4bit にあり、この形式はその位置をそのまま保存する。
- RFC 9562 の Sections 4.1–5.10 は variant と version 1–8、Nil、Max、予約範囲を区別する。RFC 9562 は RFC 4122 を置き換えるので、この形式の現行の規範は RFC 9562 である。
- RFC 9562 の hex-and-dash ABNF は text 表現であり、COM GUID の little-endian に関する注意も別に述べている。GEUL は RFC UUID の canonical な 16 octet だけを Payload に入れる。
- GEUL の TAG、直接 Length、16bit WORD framing は RFC 9562 の一部ではなく、この形式が加える規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 8 WORD を合わせたちょうど 9 WORD で、直接長 `LLLL=1000` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例 {#예시}

RFC 9562 Appendix A.6 の UUIDv7 test vector `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`、Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000007B0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
