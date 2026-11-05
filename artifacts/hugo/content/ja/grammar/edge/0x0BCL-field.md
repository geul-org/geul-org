---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD は、Codec Payload のフィールド一つを宣言する叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `FIELD` (規格ドキュメント BIND `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| 規格ドキュメント | `0x00000000/codecs/0x00000BC0/` (DECLARE 対象 `0BC0`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 28 |
| Kind | Edge · 系列: 叙述、まとまり: その他 |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Payload のフィールド一つ。所属する DECLARE、幅: レコード(TAG の Length)または生値 n WORD |
| Hugo 側 | `edge/field.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | レコード | `0050` LOCAL |  |
| 2 | `width` | #3 | 生値 1 WORD |  | `0x0000` record, `0xFFFF` rest |

FIELD は、Codec Payload のフィールド一つを宣言する叙述 Edge である。Codec `0x0BCL`。

FIELD が自分の [DECLARE](0x0BBL-declare.md) を指す。一つの DECLARE を指す FIELD たちが、ドキュメント内の順序どおりに Payload を構成する。レイアウトはデコーダに内蔵する([Codec 規格ドキュメント](../codec-spec.md))。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           LOCAL Reference レコード
DECLARE           LOCAL Reference レコード。このフィールドが属する DECLARE Edge
幅                1 WORD。0 = レコード、n (1~65534) = 生値 n WORD、0xFFFF = 残りの生値
```

## 解釈と有効性 {#해석과-유효성}

- DECLARE は同じドキュメントの DECLARE Edge を指す。FIELD 一つは DECLARE 一つにのみ属する。順序は別に記さず、FIELD レコードがドキュメントに置かれた順序である。
- FIELD 規格ドキュメントは、DECLARE を幅 `0`(レコード)、CODEC `0050`(LOCAL)のフィールドとして宣言する。そのため、ビューアのグラフでは FIELD → DECLARE の接続として描かれる。
- 幅 `0` はレコードフィールドである。TAG WORD で始まり、その TAG の Length だけ読む([DECLARE](0x0BBL-declare.md) の解釈規則)。
- 幅 `n`(1~65534)は生値フィールドである。常にちょうど n WORD である。
- 幅 `0xFFFF` は残りの生値である。DECLARE に一つだけ置き、前・中間・末尾のどこでもよい。幅は、外側のレコードの TAG の Length が定める残りの WORD から、後ろのフィールドの幅を引いた値である。そのため、残りのフィールドの後ろのフィールドはすべて固定幅の生値でなければならない(レコードは前から読まないと終端が分からない)。0 WORD でもよい。ENUM は付けない。
- フィールドが受け取る Kind・Codec は [CODEC](0x0BEL-codec.md) で指定する。レコードフィールドは、CODEC がなければ任意のレコードを受け取り、あればそのうちの一つでなければならない。生値フィールドに CODEC を一つ置くと、その生値を TAG を除いたその Value として解釈する。
- フィールド名は FIELD の Edge Id に [BIND](0x0A3L-bind.md) で結びつける(例: `doc`、`hash`)。DECLARE・FIELD・ENUM・CODEC に付ける UTF8-TEXT はすべて BIND で行い、LABEL など他の Edge では付けない。
- 生値フィールドのコード値の意味は [ENUM](0x0BDL-enum.md) で付ける。
- グラフで他のノードを指すフィールドは、別に表示しない。レコードフィールドが Reference であれば、それが接続である。

## 長さ {#길이}

```
全体 = 1 + 2 + 2 + 1 WORD   (Edge Id・DECLARE が LOCAL 1 WORD ID のとき)
```

## 例 (非規範) {#예시-비규범}

- レコードフィールド: Edge Id 7、DECLARE #1、幅 `0`。TAG 1 + Edge Id 2 + DECLARE 2 + 幅 1 = 6 WORD。LOCAL だけを受け取るようにするには [CODEC](0x0BEL-codec.md) の例を見る。

```
0BC5 0051 0007 0051 0001 0000
```

- コンテンツハッシュのような生値フィールドは [DECLARE](0x0BBL-declare.md) の例を見る。

## 関連ページ {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Codec 規格ドキュメント](../codec-spec.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000BC0/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
