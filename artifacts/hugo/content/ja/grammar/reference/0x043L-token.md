---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T20:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN は GEUL トークン語彙の項目 1 つを指す 2 WORD の Reference だ。続けて書いた TOKEN レコードのバイトをつなぐと元のテキストになる。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | TOKEN-0 | TOKEN-1 |
|---|---|---|
| 名前 | `TOKEN-0` (規格ドキュメント BIND `TOKEN-0`) | `TOKEN-1` (規格ドキュメント BIND `TOKEN-1`) |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| 規格ドキュメント | `0x00000000/codecs/0x00000430/` (DECLARE 対象 `0430`) | `0x00000000/codecs/0x00000440/` (DECLARE 対象 `0440`) |
| セクション | 2 `0010` (Reference その他)、セクション内オフセット C = 3 | 2 `0010`、C = 4 |
| Kind | Reference · 分類: 宣言 | Reference · 分類: 宣言 |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| トークン ID | `0`~`65,535` | `65,536`~`131,071` |
| Hugo 側 | `reference/token.md` | `reference/token.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `token-id` | #2 | 生値 1 WORD |  | ENUM 60,536 個(トークン ID `0x0000`~`0xEC77`)。例: `0x0000` `<0x00>`, `0x021B` 가, `0x2DE5` ` the`, `0xE75E` 한국 … |

TOKEN は GEUL トークン語彙の項目 1 つを指す Reference だ。語彙は韓国語と英語を対象に学習した BPE(Byte Pair Encoding)語彙で、項目 1 つはバイト列 1 つである。続けて書いた TOKEN レコードのバイト列を順番につなぐと、元のテキストのバイトになる。

- 語彙が 65,536 個以内なら TOKEN-0 だけを使う。それより大きくなったら、あふれた項目を TOKEN-1 に置く。TOKEN-1 を使わなくても、最初の Codec の名前は TOKEN-0 である。
- トークン 1 つを 1 レコードで書く。サイズが 2 WORD に固定なので、トークン列の k 番目のレコードは先頭から 4k バイト離れた位置にある。

## レイアウト {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, 全体 2 WORD
Payload WORD 1st (16 ビット)           トークン ID (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, 全体 2 WORD
Payload WORD 1st (16 ビット)           トークン ID − 65,536 (uint16)
```

- コード: Reference 直接コード `0x043L`·`0x044L`(セクション 2)。
- Payload は対象 ID だ。[Reference 共通レイアウト](_index.md)のとおり、符号なしビッグエンディアン整数を最も短い幅で書くが、対象 ID が常に `0`~`65,535` なので Payload は常に 1 WORD である(`0` は `0x0000`)。
- 量化はない(量化は 5Q 体系でのみ読む)。

## 解釈と有効性 {#해석과-유효성}

- 各 Codec の対象 ID は Payload の値である。語彙全体でのトークン ID は、TOKEN-0 なら対象 ID、TOKEN-1 なら 65,536 + 対象 ID である。
- トークンの正式な表現は、その Codec の規格ドキュメントである。トークン ID ごとに FIELD `token-id` に [ENUM](../edge/0x0BDL-enum.md) が 1 つあり、その ENUM Edge Id に [BIND](../edge/0x0A3L-bind.md) で結ばれた名前がトークンのバイト列である。TOKEN-1 の ENUM コード値は Payload の値(トークン ID − 65,536)である。
- 語彙は閉じた一覧である。規格ドキュメントに ENUM がないトークン ID は invalid である。ENUM の一般規則(「宣言されていないコード値はエラーではない」)よりこの Codec の規則が優先する。
- **バイトトークン:** トークン ID `0`~`255` は 1 バイトである。トークン ID がそのままバイト値である。韓国語・英語以外の文字のように語彙にない文字は、その UTF-8 バイトをバイトトークンで書く。バイトトークンの BIND 名は機械名 `<0x00>`~`<0xFF>` で、意味はこの規則が定める。
- **それ以外のトークン:** バイト列が正しい UTF-8 で、BIND 名がそのバイト列そのものである。
- **デコード:** TOKEN レコード列を先頭から読み、各トークンのバイト列をつなぐ。バイトトークンが続いて作る UTF-8 の文字も、この連結で復元される。結果はエンコード前のテキストとバイト単位まで同じである。
- **エンコード:** テキストをトークン列に分ける方法(分割規則とマージ順序)は語彙の版に属する。同じテキストでも語彙の版が違えばトークン列が違うことがある。デコード結果は版に関係なく同じである。
- **版:** 語彙の版は規格ドキュメントのバージョンである。各版は語彙ファイルと学習記録のハッシュを、規格ドキュメント HEAD の [SOURCE](../edge/0x0C0L-source.md) として書く。トークン列を作った版を明らかにする必要があるときは、そのバージョン([CODEC-POINTER](0x042L-codec-pointer.md)(`0x00000000`、`0x00000430`、バージョン ID `n`))を一緒に残す。
- **追加のみ:** 新しい版は ENUM と BIND を後ろに追加するだけである。一度与えたトークン ID のバイト列は変えず、削除も書き直しもしない。そのため、どの版も前の版の上位集合であり、前の版で作ったトークン列は後の版でも同じようにデコードされる。語彙を最初から学習し直して意味が変わる場合は、この Codec を使わず、新しい Codec 番号の割り当てを受ける。
- トークンは Reference なので、[BIND](../edge/0x0A3L-bind.md)、[LABEL](../edge/0x0A4L-label.md)、[TRIPLE](../edge/0x0AAL-triple.md) の主語になれる(例: トークンの出現頻度、言語)。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 1 WORD を合わせたちょうど 2 WORD で、直接長 `LLLL=0001` を使う。Length 拡張 TAG、Codec 拡張 TAG、Codec 別 TAG はない。
- Payload がちょうど 1 WORD でなければ拒否する。

## 例 {#예시}

語彙の版 1(規格ドキュメント `0x00000000/codecs/0x00000430` バージョン 1)の番号である。トークン 60,536 個を割り当てた: バイト 256、基本文字 283(空白・改行・タブ、ASCII、ハングル字母、記号)、ハングル音節 11,172(`0x021B` 가 ~ `0x2DBE` 힣)、マージ 48,825。`0xEC78`~`0xFFFF` は追加用に空けてある。

| トークン(バイト列) | トークン ID | 全体の WORD |
|---|---|---|
| バイト `0xE3` | `0x00E3` | `0431 00E3` |
| `가` | `0x021B` | `0431 021B` |
| ` the` (前に空白) | `0x2DE5` | `0431 2DE5` |
| ` GEUL` (前に空白) | `0x377F` | `0431 377F` |
| `한국어` | `0xD0B8` | `0431 D0B8` |

- 規格ドキュメントでは、` the` は `ENUM #2 0x2DE5` と、その Edge Id に結び付けた `BIND " the"` である。
- 空白は後ろの単語に付く。そのため ` the` と `the`(`0x328D`)は別のトークンである。

## 未解決の問題 {#열린-문제}

- トークン列をドキュメントに入れる形式。どの Edge や Value のフィールドが TOKEN レコード列を受けるかは決めていない。
- エンコードの正規形。分割規則とマージ順序を規格ドキュメントにどう書くか、同じテキストのトークン列を 1 つに定めるか。
- 版の間の解釈。読む側が持つ版より新しいトークン ID に出会ったとき、invalid として捨てるか、元の値を保存したまま「未知のトークン」として扱うか。

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[CODEC-POINTER](0x042L-codec-pointer.md)
- [Codec 規格ドキュメント](../codec-spec.md)、[ENUM](../edge/0x0BDL-enum.md)、[BIND](../edge/0x0A3L-bind.md)、[SOURCE](../edge/0x0C0L-source.md)
- 同じ形のレジストリ: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000430/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。 HEAD の 2 つの SOURCE は、語彙ファイルと学習記録の SHA-256 である。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000043000000000
#121077 SOURCE #0 ABSENT
#121078 QUALIFIER P4092 #121077 SHA-256-DIGEST(0xE4DEEA8BA9FE74BEAAD836FEBE06CF4DAC32B30D1E9A85308D0A6E0A9CB6A417)
#121079 SOURCE #0 ABSENT
#121080 QUALIFIER P4092 #121079 SHA-256-DIGEST(0x5B2C82701BCFFD3589DC9640B398B3F07F0AC7F18E483486AF5221C3D30D4D9C)
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "token-id"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
#7 ENUM #2 0x0001
#8 BIND #7 "<0x01>"
… (ENUM·BIND 121,064 行を省略)
#121073 ENUM #2 0xEC76
#121074 BIND #121073 "etap"
#121075 ENUM #2 0xEC77
#121076 BIND #121075 " Aman"
```
