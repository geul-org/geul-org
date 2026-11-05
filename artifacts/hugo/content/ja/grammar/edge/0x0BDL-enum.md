---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM は、生値フィールドのコード値一つに意味を付ける叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `ENUM` (規格ドキュメント BIND `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| 規格ドキュメント | `0x00000000/codecs/0x00000BD0/` (DECLARE 対象 `0BD0`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 29 |
| Kind | Edge · 系列: 叙述、まとまり: その他 |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 生値フィールドのコード値一つ。フィールド、コード値 |
| Hugo 側 | `edge/enum.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | レコード | `0050` LOCAL |  |
| 2 | `code` | #3 | 残りの生値(`0xFFFF`) |  |  |

ENUM は、生値フィールドのコード値一つに意味を付ける叙述 Edge である。Codec `0x0BDL`。

[FIELD](0x0BCL-field.md) とともに Codec 規格を書く語彙である。レイアウトはデコーダに内蔵する([Codec 規格ドキュメント](../codec-spec.md))。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
フィールド        FIELD Edge を指す LOCAL Reference レコード
コード値          生値。その FIELD の幅と同じ WORD 数
```

## 解釈と有効性 {#해석과-유효성}

- フィールドは生値の FIELD(幅 `n ≥ 1`)でなければならない。レコードフィールドには ENUM を付けない。レコードの意味は、そのレコードの Codec が語る。
- コード値は、ちょうどその FIELD の幅である。ENUM レコードの Length で境界を確認する。
- 一つのフィールドで同じコード値を二度宣言しない。
- コード値の名前は ENUM の Edge Id に [BIND](0x0A3L-bind.md) で結びつける。DECLARE・FIELD・ENUM・CODEC に付ける UTF8-TEXT はすべて BIND で行い、LABEL など他の Edge では付けない。
- 宣言されていないコード値はエラーではない。ビューアは生値のまま表示する。許容値を閉じるかどうかは Codec 規格の役割であり、現在の語彙には閉じる表示がない。

## 長さ {#길이}

```
全体 = 1 + N_len + N_id + N_field + n WORD
```

## 例 (非規範) {#예시-비규범}

TOMBSTONE 規格ドキュメントの理由区分フィールド(FIELD #4、生値 1 WORD)にコード `0x0001` を宣言する。Edge Id 10。名前は BIND で別に結びつける。理由区分のコード表はまだ定まっていないので、コード値は例である。

- TAG 1 + Edge Id 2 + フィールド 2 + コード値 1 = 6 WORD、`LLLL = 0101`。

```
0BD5 0051 000A 0051 0004 0001
```

TRIPLE 規格ドキュメントは Rank フィールド(FIELD #5)に ENUM を三つ(`0`・`1`・`2`)置き、それぞれ `normal`・`preferred`・`deprecated` に BIND する([TRIPLE](0x0AAL-triple.md))。

## 関連ページ {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Codec 規格ドキュメント](../codec-spec.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000BD0/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
