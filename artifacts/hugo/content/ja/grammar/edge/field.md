---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD は Codec Payload のフィールド一つを宣言する記述 Edge だ(Codec 0x1C)。属する DECLARE と幅(レコード、生値 n WORD、残り生値)を書く。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD は、Codec Payload のフィールド一つを宣言する記述 Edge だ。Codec `0x1C`。

FIELD が自分の [DECLARE](/ja/grammar/edge/declare/) を指す。一つの DECLARE を指す FIELD 群が、ドキュメント内の順序どおりに Payload を構成する。レイアウトはデコーダに内蔵する([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。

## レイアウト

```
TAG WORD          0001 0LLL L001 1100
Edge Id           LOCAL Reference レコード
DECLARE           LOCAL Reference レコード。このフィールドが属する DECLARE Edge
幅                1 WORD。0 = レコード、n (1~65534) = 生値 n WORD、0xFFFF = 残り生値
```

## 解釈と有効性

- DECLARE は同じドキュメントの DECLARE Edge を指す。FIELD 一つは DECLARE 一つにだけ属する。順序は別に書かず、FIELD レコードがドキュメントに置かれた順序だ。
- FIELD 規格ドキュメントは、DECLARE を幅 `0`(レコード)、CODEC `0008`(LOCAL)のフィールドとして宣言する。そのためビューアのグラフで FIELD → DECLARE の接続として描かれる。
- 幅 `0` はレコードフィールドだ。TAG WORD で始まり、その TAG の Length だけ読む([DECLARE](/ja/grammar/edge/declare/) の解釈規則)。
- 幅 `n`(1~65534)は生値フィールドだ。常にちょうど n WORD だ。
- 幅 `0xFFFF` は残り生値だ。DECLARE に一つだけ置き、先頭・中間・末尾のどこでもよい。幅は、外側のレコードの TAG Length が決めた残り WORD から、後ろのフィールドの幅を引いた値だ。そのため残りフィールドの後ろのフィールドは、すべて固定幅の生値でなければならない(レコードは先頭から読まないと終わりが分からない)。0 WORD でもよい。ENUM は付けない。
- フィールドが受け取る Kind・Codec は [CODEC](/ja/grammar/edge/codec/) で指定する。レコードフィールドは CODEC がなければ任意のレコードを受け付け、あればそのいずれかでなければならない。生値フィールドに CODEC を一つ置くと、その生値を TAG を除いたその Value として解釈する。
- フィールド名は FIELD の Edge Id に [BIND](/ja/grammar/edge/bind/) で結びつける(例: `doc`、`hash`)。DECLARE・FIELD・ENUM・CODEC に付ける UTF8-TEXT はすべて BIND で行い、LABEL など他の Edge では付けない。
- 生値フィールドのコード値の意味は [ENUM](/ja/grammar/edge/enum/) で付ける。
- グラフで他のノードを指すフィールドは、別に表示しない。レコードフィールドが Reference なら、それが接続だ。

## 長さ

```
全体 = 1 + 2 + 2 + 1 WORD   (Edge Id・DECLARE が LOCAL 1 WORD ID のとき)
```

## 例 (非規範)

- レコードフィールド: Edge Id 7、DECLARE #1、幅 `0`。TAG 1 + Edge Id 2 + DECLARE 2 + 幅 1 = 6 WORD。LOCAL だけを受け取るようにするには [CODEC](/ja/grammar/edge/codec/) の例を見る。

```
129C 0088 0007 0088 0001 0000
```

- コンテンツハッシュのような生値フィールドは [DECLARE](/ja/grammar/edge/declare/) の例を見る。

## 関連ページ

- [DECLARE](/ja/grammar/edge/declare/)、[ENUM](/ja/grammar/edge/enum/)、[CODEC](/ja/grammar/edge/codec/)、[BIND](/ja/grammar/edge/bind/)
- [Codec 規格ドキュメント](/ja/grammar/codec-spec/)
