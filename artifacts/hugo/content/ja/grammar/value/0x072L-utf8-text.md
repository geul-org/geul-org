---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT は言語を持たない UTF-8 文字列を収める Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT は言語を持たない UTF-8 文字列を収める Value である。偶数·奇数バイトのコードの組 0x072L/0x073L を使う。

| 項目 | 値 |
|---|---|
| 名前 | `UTF8-TEXT` (偶奇の組。コードごとの名前は下の構成員の表) |
| TAG ID | `0x072L`·`0x073L` |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 18~19 |
| Kind | Value · 系列: TEXT |
| 索引の説明 | 正規化を含意しない valid UTF-8 バイト列。偶数·奇数バイト |
| Hugo 側 | `value/text/utf8-text.md` |

## 構成員 {#구성원}

このページは偶奇の組をなす二つのコードをまとめて扱う。偶数コードはバイト数が偶数、奇数コードは奇数の値である([レコードと TAG WORD](../record.md#가변-길이-바이트열))。Codec ドキュメントはコードごとに一つである。二つの Codec ドキュメントのフィールドは同じで、DECLARE の対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | バイト数 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | 偶数 | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | 奇数 | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 残り生値(`0xFFFF`) |  |  |

UTF8-TEXT は RFC 3629 の valid UTF-8 バイト列を収める Value である。識別子、コード、ファイル名のように言語を持たない文字列に使う。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x072L`(偶数バイト)·`0x073L`(奇数バイト)。系列 TEXT。
- バイト数は Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット`であり、Byte Count は置かない([Value](_index.md))。

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## 解釈と有効性 {#해석과-유효성}

- バイト列は RFC 3629 の文法に合う well-formed shortest-form UTF-8 でなければならない。デコード結果は `U+0000..U+10FFFF` の範囲の Unicode scalar value だけを含み、サロゲート範囲 `U+D800..U+DFFF` は含まない。
- Payload 先頭の U+FEFF(UTF-8 バイト列 `EF BB BF`)も、他の位置の U+FEFF と同じ文字とみなして許す。RFC 3629 が説明する先頭 U+FEFF の signature(BOM)処理は行わない。取り除いたり signature として解釈したりせず、原文のまま保存する。
- Unicode normalization は強制しない。デコードした原文の scalar sequence をそのまま保存する。
- 有効な UTF-8 バイト列を変換せずに Payload に置く。WORD の中では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload WORD 数は `ceil(バイト数/2)` である。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準の根拠 {#표준-근거}

- UTF-8 の scalar 範囲と well-formed バイト列は [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629) に従う。
- 偶奇のコードの組、zero padding、GEUL の TAG/Length と 16 ビット WORD の配置は、この形式の canonical framing 規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`·`1111` の拡張長を使い、拡張 TAG も全体の数に含める([Length](../record.md))。
- 0 byte の文字列は偶数コードの 1 WORD レコード(TAG WORD のみ)で書く([Value](_index.md))。

## 例 {#예시}

- `A`(`41`)は 1 byte(奇数)なので `UTF8-TEXT-ODD`(`0x073L`)、Payload `4100`、全体 2 WORD、`LLLL=0001` である。全体は `0731 4100` である。
- 空文字列は `0720`(`UTF8-TEXT-EVEN`、TAG WORD のみ)の 1 WORD である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000720/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

上は `UTF8-TEXT-EVEN`(`0x072L`)の Codec ドキュメントである。他の構成員(`UTF8-TEXT-ODD`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE の対象、`#1` に結び付けた名前(BIND)だけが異なる。
