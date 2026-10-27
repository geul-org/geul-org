---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE は Codec 一つの Payload 構成を宣言する記述 Edge だ(Codec 0x1B)。FIELD・ENUM・CODEC とともに Codec 規格ドキュメントを書く語彙だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE は、Codec 一つの Payload 構成を宣言する記述 Edge だ。Codec `0x1B`。

[FIELD](/ja/grammar/edge/field/)(`0x1C`)、[ENUM](/ja/grammar/edge/enum/)(`0x1D`)、[CODEC](/ja/grammar/edge/codec/)(`0x1E`)とともに、Codec 規格を書く語彙だ([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。四つの Edge のレイアウトはデコーダに内蔵する。この語彙で書いた各 Codec 規格ドキュメントは通常のドキュメントだ。規格一つで検証、分解、表示(ビューア)をまとめて行う。ビューアは Codec ごとにコードを持たず、規格どおりに描く。

## レイアウト

```
TAG WORD          0001 0LLL L001 1011
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
対象              1 WORD。宣言する Codec の TAG WORD から Kind・Codec の位置だけを使う (LLLL = 0)
[Issuer・形式番号] 対象が Issuer 形式のとき。Codec 拡張 TAG と同じレイアウト
```

- フィールド一覧は DECLARE に置かない。各 [FIELD](/ja/grammar/edge/field/) が自分の DECLARE を指し、その FIELD 群のドキュメント内の順序が Payload のフィールド順序だ。

## 解釈規則

Codec 規格でレコードを読み、表記する規則だ。

- 生値フィールドは、FIELD が宣言した固定 WORD 数だけ読む。フィールド一つは残り生値(幅 `0xFFFF`)でもよく、残りの WORD からその後ろの固定フィールドの幅を引いた分だけ読む。残りフィールドの後ろには固定幅の生値だけを置く。
- レコードフィールドは TAG WORD で始まり、その TAG の Length だけ読む。
- 生値フィールドは n WORD のビッグエンディアン符号なし整数だ。表記は `0x` + 幅×4桁の hex で、同じ値の ENUM があればその BIND 名を併記する。
- レコードフィールドの意味は、そのレコードの Codec 規格が決める。符号・小数・日付のように解釈が必要な値は、生値ではなく Value レコードで置く。

それ以外の境界規則はない。可変の生値が二つ以上ある Codec、可変の生値の後ろにレコードや可変フィールドが来る Codec、生値の幅が他のフィールドの値やドキュメントの状態で変わる Codec は、この語彙では宣言できない。そのようなレイアウトは、可変部分をレコードで包んで一つだけ残す(例: SIGNATURE の署名者は Reference レコード)。

## 有効性

- 対象の Kind は Reference、Value、Edge、Meta のいずれかだ。Reference の Codec は `CCCC` の位置で、Quantifier は 0 にする。
- [プレースホルダ](/ja/grammar/reference/slot-marker/)(Reference Codec `0000`)は DECLARE の対象になれない。デコーダに内蔵する(0 層)。
- Edge の Edge Id は FIELD として宣言しない。すべての Edge の最初の要素なので暗黙だ([Edge](/ja/grammar/edge/))。
- DECLARE のフィールドは、それを指す FIELD 群で、0個でもよい。FIELD 一つは DECLARE 一つにだけ属する。同じ形のフィールドでも DECLARE ごとに FIELD を別に置く。
- DECLARE には、対象(と Issuer 形式対象の Issuer・形式番号)以外に何もない。
- フィールドを順に読んだカーソルは、レコードの終わりとちょうど合わなければならない。余ったり足りなかったりすれば、そのレコードは規格違反だ。
- 一つのドキュメントで同じ対象を二度宣言しない。
- 末尾フィールドが異なる変種を分岐として使わない。Codec ごとに DECLARE を別に置く。

## 規格ドキュメント

- 直接コードの規格ドキュメントは、GEUL Issuer `0x0000` の通常のドキュメントだ。ドキュメント ID は対象 TAG WORD を 4 WORD に伸ばした値で(`0x1018` → `0x0000000000001018`)、他の Issuer ドキュメントと同じ方式(バージョン ID、`versions.geul`)で公表する([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。
- 規格ドキュメント一つに DECLARE は一つで、その対象がドキュメント ID の TAG WORD と同じでなければならない。`DOC-ID` は DOC-POINTER(`0x0000`、そのドキュメント ID、`0`)だ。

## 名前

- Codec 名は DECLARE の Edge Id に [BIND](/ja/grammar/edge/bind/) で結びつける(例: `PUBLICATION`)。DECLARE・FIELD・ENUM・CODEC に付ける UTF8-TEXT はすべて BIND で行い、LABEL など他の Edge では付けない。
- フィールド名と enum 名も同じ方式で FIELD・ENUM に結びつける。

## 例

PUBLICATION(Edge `0x18`)の規格ドキュメント `geul.org/publication`: Edge Id の次に DOC-POINTER レコード、コンテンツハッシュ 16 WORD。

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, レコード       (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, 生値 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + 対象 1 = 4 WORD、`LLLL = 0011`。
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + 幅 1 = 6 WORD(`LLLL = 0101`)。受け取る Kind・Codec は [CODEC](/ja/grammar/edge/codec/) で別に置く(`0038` = DOC-POINTER)。
- オプションフィールドは CODEC 対象 `0000` で宣言する。省略した位置には ABSENT(`0x0000`)を書く([CODEC](/ja/grammar/edge/codec/) のオプションフィールド)。
- フィールドの順序は、FIELD #2、#4 がドキュメントに置かれた順序だ。Edge Id は連続していなくてもよい(LOCAL AUTO INCREMENT は推奨)。

## 未解決の問題

- 繰り返し。`CALL` の「引数 × 引数の数」のように、前の生値が個数を決める構成。今は宣言できない。
- 下位形式(Codec ごとの TAG)を持つ Codec(WORLD など)の宣言方法。
- Issuer 形式の規格ドキュメントを見つける方法(Issuer・形式番号 → 規格ドキュメントのアドレス)。
- `SPEC-VERSION` が、直接コード規格ドキュメント群のどのバージョンの組を意味するか。

## 関連ページ

- [FIELD](/ja/grammar/edge/field/)、[ENUM](/ja/grammar/edge/enum/)、[CODEC](/ja/grammar/edge/codec/)、[BIND](/ja/grammar/edge/bind/)
- [Edge](/ja/grammar/edge/)、[Codec 規格ドキュメント](/ja/grammar/codec-spec/)
