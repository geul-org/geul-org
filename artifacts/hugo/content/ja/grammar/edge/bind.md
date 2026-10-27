---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND は Subject に機械が突き合わせる名前(言語のない UTF8-TEXT)を結びつける記述 Edge だ(Codec 0x03)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND は、Subject に機械が突き合わせる名前を結びつける記述 Edge だ。Codec `0x03`。

命名だ。人が読む名前(言語別のタイトル)は [LABEL](/ja/grammar/edge/label/) が担う。プログラムシンボルの名前と、ドキュメントのアドレス用の名前を同じレコードで書く。

## レイアウト

```
TAG WORD          0001 0LLL L000 0011
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個、またはコーデック TAG WORD 1 WORD
名前              UTF8-TEXT-* Value 1個
```

## 解釈と有効性

- Subject は、ちょうど一つの完全な [Reference](/ja/grammar/reference/) レコードだ。LOCAL ならこのドキュメントの対象(シンボルなど)、指示 Reference なら他のドキュメントの対象だ。ドキュメント自身は [DOC-POINTER](/ja/grammar/reference/doc-pointer/)、Issuer 自身は [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) だ。
- または Subject はコーデック TAG WORD 一つ(Kind・Codec だけ、`LLLL = 0`、Payload なし)だ。これは Payload が空のレコードではなく、その直接コード自体、つまりその規格ドキュメント(GEUL Issuer ドキュメント `0x000000000000<TAG>`)を指す([Codec 規格ドキュメント](/ja/grammar/codec-spec/)、[DECLARE](/ja/grammar/edge/declare/))。例: `1018` は PUBLICATION。名前索引では DOC-POINTER Subject を使う。Issuer 形式のコーデックは使わない。
- それ以外のレコード(Value など)は Subject になれない。BIND 規格ドキュメントの FIELD は Subject を幅 `0`(レコード)としてだけ宣言するので、この制約は BIND 本文の規則だ。
- 名前は、ちょうど一つの [UTF8-TEXT](/ja/grammar/value/text/utf8-text/) Value だ。言語はなく、正規化しない。バイトが同じなら同じ名前だ。
- 名前の範囲は、BIND を収めるドキュメントだ。一つのドキュメントで同じ名前を異なる Subject に結びつけない。
- 一つの Subject に複数の名前を結びつけられる(別名、旧名)。ドキュメントが別に定めない限り、最後の BIND が代表名だ。
- 他のレコードは名前ではなく LOCAL ID で対象を指す。名前は外部(ホスト関数、アドレス入力、人)との突き合わせに使う。
- 名前に使える文字は用途が決める。ドキュメントアドレス用の名前は、ドキュメント名の規則(小文字 ASCII のスラッグ)に従う([公表アドレスとバージョン一覧](/ja/grammar/publishing/#ドキュメント名))。

## 長さ

```
全体 = 1 + N_len + N_id + N_subject + N_name WORD
```

## 例 (非規範)

プログラムシンボル: Edge Id `0003`、Subject LOCAL 7、名前 `main`。

- 名前 `main` は 4 byte(偶数)なので `0940 6d61 696e` の 3 WORD だ。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + 名前 3 = 8 WORD、TAG `1383` だ。

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

ドキュメント名(そのドキュメントのバージョン一覧ドキュメント `0x0000/0xffff000000000002/versions.geul` の中): Edge Id `0005`、Subject `DOC-POINTER`(Issuer `0x0000`、ドキュメント `0xffff000000000002`、バージョン `0` = ドキュメント自身)、名前 `this-is-sample-doc`。

- Subject は TAG `03B8` + Issuer 1 + ドキュメント ID 4 + バージョン ID 2 = 8 WORD だ。
- 名前は 18 byte(偶数)なので TAG `0CC0` + 9 WORD = 10 WORD だ。
- Edge は TAG 1 + Length 拡張 1 + Edge Id 2 + Subject 8 + 名前 10 = 22 WORD なので `LLLL=1110`、TAG `1703`、拡張 `0016` だ。

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## 関連ページ

- [Edge](/ja/grammar/edge/)、[LABEL](/ja/grammar/edge/label/)、[PUBLICATION](/ja/grammar/edge/publication/) (バージョン一覧ドキュメントのドキュメント名)
- [LOCAL](/ja/grammar/reference/local/)、[DOC-POINTER](/ja/grammar/reference/doc-pointer/)、[ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/)
