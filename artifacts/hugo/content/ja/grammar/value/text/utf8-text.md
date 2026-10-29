---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT は、言語のない UTF-8 文字列を収める Value だ。偶数・奇数バイトのコードペア 0x40/0x41 を使う。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT は、RFC 3629 の valid な UTF-8 バイト列を収める Value だ。識別子、コード、ファイル名のように言語のない文字列に使う。

## レイアウト

- コード: Value 直接コード `0x40`(偶数バイト)・`0x41`(奇数バイト)。系列 TEXT。
- バイト数は、Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` で、Byte Count は置かない([Value](/ja/grammar/value/))。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## 解釈と有効性

- バイト列は、RFC 3629 の文法に合う well-formed な shortest-form UTF-8 でなければならない。デコード結果は `U+0000..U+10FFFF` の範囲の Unicode scalar value だけを含み、surrogate 範囲 `U+D800..U+DFFF` は含まない。
- Payload 先頭の U+FEFF(UTF-8 バイト列 `EF BB BF`)も、他の位置の U+FEFF と同じく文字として許可する。RFC 3629 が説明する先頭 U+FEFF signature(BOM)の扱いは適用しない。取り除いたり signature として解釈したりせず、原文のまま保存する。
- Unicode 正規化は強制しない。デコードした原文の scalar sequence をそのまま保存する。
- 有効な UTF-8 バイト列を、変換せずに Payload に置く。WORD の中では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload WORD 数は `ceil(バイト数/2)` だ。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準の根拠

- UTF-8 の scalar 範囲と well-formed なバイト列は、[RFC 3629](https://www.rfc-editor.org/rfc/rfc3629) に従う。
- 偶奇コードのペア、zero padding、GEUL TAG/Length と 16ビット WORD の配置は、この形式の canonical framing 規則だ。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に含める([Length](/ja/grammar/record/))。
- 0 byte の文字列は、偶数コードの 1 WORD レコード(TAG WORD のみ)で書く([Value](/ja/grammar/value/))。

## 例

- `A`(`41`)は 1 byte(奇数)なので `UTF8-TEXT-ODD`(`0x41`)、Payload `4100`、全体 2 WORD、`LLLL=0001` だ。全体は `08C1 4100` だ。
- 空文字列は `0840`(`UTF8-TEXT-EVEN`、TAG WORD のみ)の 1 WORD だ。
