---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND は、Subject に機械が照合する名前を結びつける叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `BIND` (規格ドキュメント BIND `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A30/` (DECLARE 対象 `0A30`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 3 |
| Kind | Edge · 系列: 叙述、まとまり: 指示と名前 |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Subject に機械が照合する名前(`UTF8-TEXT-*`)を結びつける。範囲内で一意で、正確に一致しなければならず、言語がない |
| Hugo 側 | `edge/bind.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `name` | #3 | レコード | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

BIND は、Subject に機械が照合する名前を結びつける叙述 Edge である。Codec `0x0A3L`。

命名である。人が読む名前(言語別のタイトル)は [LABEL](0x0A4L-label.md) が担う。プログラム記号の名前と Issuer 一覧のドメイン名を同じレコードで書く。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個、または Codec TAG WORD 1 WORD
名前              UTF8-TEXT-* Value 1個
```

## 解釈と有効性 {#해석과-유효성}

- Subject は、ちょうど一つの完全な [Reference](../reference/_index.md) レコードである。LOCAL ならこのドキュメントの対象(記号など)、指示 Reference なら別のドキュメントの対象である。ドキュメント自身は [DOC-POINTER](../reference/0x041L-doc-pointer.md)、Issuer 自身は [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) である。
- または Subject は Codec TAG WORD 一つ(Kind・Codec のみ、`LLLL = 0`、Payload なし)である。これは Payload が空のレコードではなく、その直接コード自体、すなわちその規格ドキュメント(GEUL Issuer の Codec `0x0000<TAG>`)を指す([Codec 規格ドキュメント](../codec-spec.md)、[DECLARE](0x0BBL-declare.md))。例: `0B80` は PUBLICATION。Issuer 形式のCodecはこの形では指さない。
- それ以外のレコード(Value など)は Subject になれない。BIND 規格ドキュメントの FIELD は Subject を幅 `0`(レコード)としてのみ宣言するので、この制約は BIND 本文の規則である。
- 名前は、ちょうど一つの [UTF8-TEXT](../value/0x072L-utf8-text.md) Value である。言語がなく、正規化しない。バイト列が同じなら同じ名前である。
- 名前の範囲は BIND を収めたドキュメントである。一つのドキュメントで同じ名前を異なる Subject に結びつけない。
- 一つの Subject に複数の名前を結びつけられる(別名、旧名)。ドキュメントが別に定めない限り、最後の BIND が代表名である。
- 他のレコードは名前ではなく LOCAL ID で対象を指す。名前は外部(ホスト関数、アドレス入力、人)との照合に使う。
- 名前に使える文字は用途が定める。Issuer 一覧のドメイン名はドメインの規則(小文字、IDNA)に従う([公表アドレスとバージョン一覧](../publishing.md#issuer-목록))。
- バージョン一覧には BIND を置かない。ドキュメント名のアドレスはない([公表アドレスとバージョン一覧](../publishing.md#문서-이름))。

## 長さ {#길이}

```
全体 = 1 + N_len + N_id + N_subject + N_name WORD
```

## 例 (非規範) {#예시-비규범}

プログラム記号: Edge Id `0003`、Subject LOCAL 7、名前 `main`。

- 名前 `main` は 4 byte(偶数)なので `0722 6D61 696E` の 3 WORD である。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + 名前 3 = 8 WORD、TAG `0A37` である。

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [公表アドレスとバージョン一覧](../publishing.md#issuer-목록) (Issuer 一覧のドメイン名)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A30/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
