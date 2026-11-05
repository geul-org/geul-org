---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE は、Codec 一つの Payload 構成を宣言する叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DECLARE` (規格ドキュメント BIND `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| 規格ドキュメント | `0x00000000/codecs/0x00000BB0/` (DECLARE 対象 `0BB0`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 27 |
| Kind | Edge · 系列: 叙述、まとまり: その他 |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Codec 一つの Payload 構成の宣言。対象 Kind・Codec |
| Hugo 側 | `edge/declare.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | 生値 1 WORD |  |  |
| 2 | `issuer` | #3 | 残りの生値(`0xFFFF`) |  |  |

DECLARE は、Codec 一つの Payload 構成を宣言する叙述 Edge である。Codec `0x0BBL`。

[FIELD](0x0BCL-field.md)(`0x0BCL`)、[ENUM](0x0BDL-enum.md)(`0x0BDL`)、[CODEC](0x0BEL-codec.md)(`0x0BEL`)とともに Codec 規格を書く語彙である([Codec 規格ドキュメント](../codec-spec.md))。四つの Edge のレイアウトはデコーダに内蔵する。この語彙で書いた各 Codec 規格ドキュメントは一般のドキュメントである。規格一つで検証、分解、表示(ビューア)をあわせて行う。ビューアは Codec ごとにコードを持たず、規格どおりに描く。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
対象              1 WORD。宣言する Codec の TAG WORD から Codec の位置(セクションと C)だけを使う (LLLL = 0)
[Issuer·Codec 番号] Issuer Codec を宣言するとき。Issuer と Codec 番号の 2 WORD。Codec 拡張 TAG と同じレイアウトで、三つの Kind で同じ
                  ISSUER コード自体の規格ドキュメント(GEUL Issuer)は対象だけを置く
```

- フィールド一覧は DECLARE に置かない。各 [FIELD](0x0BCL-field.md) が自分の DECLARE を指し、それらの FIELD のドキュメント内の順序が Payload のフィールド順序である。

## 解釈規則 {#해석-규칙}

Codec 規格でレコードを読み、表記する規則である。

- 生値フィールドは、FIELD が宣言した固定の WORD 数だけ読む。フィールド一つは残りの生値(幅 `0xFFFF`)でもよく、残りの WORD からその後ろの固定フィールドの幅を引いた分だけ読む。残りのフィールドの後ろには固定幅の生値だけを置く。
- レコードフィールドは TAG WORD で始まり、その TAG の Length だけ読む。
- 生値フィールドは n WORD のビッグエンディアン符号なし整数である。表記は `0x` + 幅×4 桁の hex であり、同じ値の ENUM があれば、その BIND 名をあわせて表記する。
- レコードフィールドの意味は、そのレコードの Codec 規格が定める。符号・小数・日付のように解釈が必要な値は、生値ではなく Value レコードに置く。

そのほかの境界規則はない。可変の生値が二つ以上ある、可変の生値の後ろにレコードや可変フィールドが来る、生値の幅が他のフィールドの値やドキュメントの状態によって変わる Codec は、この語彙では宣言できない。そのようなレイアウトは、可変の部分をレコードで包んで一つだけ残す(例: SIGNATURE の署名者は Reference レコード)。

## 有効性 {#유효성}

- 対象の Kind は Reference、Value、Edge、Meta のいずれかである。GEUL 直接コードの規格ドキュメントはコードごとに一つである。Reference の 5Q 体系も量化コードごとに別々に宣言する(LOCAL Identified `0050`、Generic `0060`、…)。ポインタ(`0x040L`、`0x041L`、`0x042L`)、プレースホルダ、ISSUER コードもそのコードのままである。ISSUER コードの後ろの Issuer・Codec 番号で定まる Issuer Codecは、その Issuer のドキュメントが定義する。
- [プレースホルダ](../slot-marker.md)(Reference `0x000L~0x002L`)も DECLARE の対象である。Payload がないので FIELD なしで DECLARE だけを置く。プレースホルダの意味と受け入れ規則はデコーダに内蔵する(0 層)。レイアウトをまだ定めていない Codec(SUPERSEDE-CHAIN、VERDICT、EVIDENCE など)も DECLARE だけを置く。
- Edge の Edge Id は FIELD で宣言しない。すべての Edge の最初の要素なので暗黙である([Edge](_index.md))。EDGE-ISSUER は Issuer・Codec 番号の後ろの最初の要素である([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md))。
- DECLARE のフィールドはそれを指す FIELD であり、0 個でもよい。FIELD 一つは DECLARE 一つにのみ属する。同じ形のフィールドでも、DECLARE ごとに FIELD を別々に置く。
- DECLARE には、対象(と Issuer 形式の対象の Issuer・Codec 番号)以外に何もない。
- フィールドを順に読み終えたカーソルは、レコードの終端とちょうど一致しなければならない。余ったり足りなかったりすれば、そのレコードは規格違反である。
- 一つのドキュメントで同じ対象を二度宣言しない。
- 末尾のフィールドが異なる変種は分岐として使わない。Codec ごとに DECLARE を別々に置く。

## 規格ドキュメント {#규격-문서}

- 直接コードの規格ドキュメントは GEUL Issuer `0x00000000` の Codec ドキュメントである。Codec ID は対象の TAG WORD(L=0)を 32 ビットで書いた値であり(`0x0B80` → `0x00000B80`)、`<Issuer>/codecs/<Codec ID>/` にバージョン ID と `versions.geul` で公表する([Codec 規格ドキュメント](../codec-spec.md))。
- Issuer Codec の Codec ドキュメントは、その Issuer の `<Issuer>/codecs/<Codec 番号>/` に置く。Codec 番号は Kind に関係なく、その Issuer 内で重複しない。解釈器は、レコードの Kind と DECLARE 対象の Kind が異なればエラーと見なす([公表アドレスとバージョン一覧](../publishing.md#id-표기))。
- 規格ドキュメント一つに DECLARE は一つであり、その対象が Codec ID の TAG WORD と同じでなければならない。`DOC-ID` は [CODEC-POINTER](../reference/0x042L-codec-pointer.md)(`0x00000000`、その Codec ID、`0`)である。

## 名前 {#이름}

- Codec 名は DECLARE の Edge Id に [BIND](0x0A3L-bind.md) で結びつける(例: `PUBLICATION`)。DECLARE・FIELD・ENUM・CODEC に付ける UTF8-TEXT はすべて BIND で行い、LABEL など他の Edge では付けない。
- フィールド名と enum 名も同じ方式で FIELD・ENUM に結びつける。

## 例 {#예시}

PUBLICATION(Edge `0x0B8L`)の規格ドキュメント `0x00000000/codecs/0x00000B80/`: Edge Id の次に DOC-POINTER レコード、コンテンツハッシュ 16 WORD。

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, レコード       (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (Codec のバージョン一覧)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, 生値 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + 対象 1 = 4 WORD、`LLLL = 0011`。
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + 幅 1 = 6 WORD(`LLLL = 0101`)。受け取る Kind・Codec は [CODEC](0x0BEL-codec.md) で別に置く(`0410` = DOC-POINTER、`0420` = CODEC-POINTER)。
- 省略可能なフィールドは CODEC の対象 `0000` で宣言する。省略した位置には ABSENT(`0x0000`)を書く([CODEC](0x0BEL-codec.md) の省略可能フィールド)。
- フィールド順序は FIELD #2、#4 がドキュメントに置かれた順序である。Edge Id は連続していなくてよい(LOCAL AUTO INCREMENT は推奨)。

## 未解決の問題 {#열린-문제}

- 繰り返し。`CALL` の「引数 × 引数の数」のように、前の生値が個数を定める構成。現在は宣言できない。
- 下位形式(Codec ごとの TAG)をもつ Codec(WORLD など)の宣言方法。
- `SPEC-VERSION` が、直接コード規格ドキュメントのどのバージョンのまとまりを意味するか。

## 関連ページ {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [Codec 規格ドキュメント](../codec-spec.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000BB0/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
