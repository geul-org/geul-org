---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "このドキュメントの識別子を宣言する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DOC-ID` (規格ドキュメント BIND `DOC-ID`) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| 規格ドキュメント | `0x00000000/codecs/0x00001C70/` (DECLARE 対象 `1C70`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 7 |
| Kind | Meta · クラス: 定義 |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | このドキュメントの識別子。埋め込み Reference `DOC-POINTER`(Issuer、ドキュメント ID、バージョン 0)。Codec ドキュメントは `CODEC-POINTER`(Issuer、Codec ID、バージョン 0) |
| Hugo 側 | `meta/declaration/doc-id.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | レコード | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

このドキュメントの識別子を宣言する。他のドキュメントがこのドキュメントとその中の対象を指すために必要である。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[Length 拡張 TAG]
ドキュメント      DOC-POINTER Reference レコード。(Issuer、ドキュメント ID、バージョン 0)。Codec ドキュメントは CODEC-POINTER
```

- Codec: Meta `0x1C7L`、定義クラス
- Payload: 埋め込み Reference [DOC-POINTER](../reference/0x041L-doc-pointer.md)(Issuer、ドキュメント ID、バージョン 0)1 つ
- 個数: 多くても 1 つ。`docs/<ドキュメント ID>/`・`codecs/<Codec ID>/` 配下のバージョンドキュメントでは必須

## 解釈と有効性 {#해석과-유효성}

- Payload は `DOC-POINTER`(Issuer、ドキュメント ID、バージョン `0`)Reference レコードちょうど 1 つである。バージョン ID は `0` のみを使う。バージョンはドキュメントではなくバージョン一覧が割り当てる。Codec ドキュメントは `CODEC-POINTER`(Issuer、Codec ID、バージョン `0`)を使う([CODEC-POINTER](../reference/0x042L-codec-pointer.md))。
- したがって「このドキュメント」を指す表記が、DOC-ID、バージョン一覧の PUBLICATION レコード、他のドキュメントの引用のいずれでも同じになる。
- バージョンに関係なく、同じドキュメントは同じ `DOC-ID` である。バージョン ID とコンテンツハッシュはドキュメントに書かない([バージョン](../document.md#버전))。
- ドキュメント名のアドレスはない([公表アドレスとバージョン一覧](../publishing.md#문서-이름))。人が読むタイトルは叙述 [LABEL](../edge/0x0A4L-label.md) が担う。
- なければ名前のないドキュメントであり、コンテンツハッシュでのみ指せる。他のドキュメントがこのドキュメントの LOCAL を指示 Reference で指すために必要である。
- ドキュメントを取得する側は、受け取ったドキュメントの `DOC-ID` が要求した Issuer・ドキュメント ID と同じか検証する。
- ドキュメント ID `0x0000000000000000` は Issuer の用語定義索引ドキュメントである([Issuer](../issuer.md))。このドキュメントも `docs/<ドキュメント ID>/` 配下のバージョンドキュメントなので DOC-ID(`DOC-POINTER`(Issuer、`0`、`0`))を置く。Issuer 自身は [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) が代表する。
- `.well-known/geul/` 配下の `<Issuer>/docs/<ドキュメント ID>/` と `<Issuer>/codecs/<Codec ID>/` のバージョンドキュメント `<バージョン ID>.geul`(規格ドキュメントを含む)は `DOC-ID` が必須である。
- 一覧ドキュメントは例外として `DOC-ID` を置かない: バージョン一覧 `versions.geul`([PUBLICATION](../edge/0x0B8L-publication.md))と Issuer 一覧 `issuers/` のバージョン `<バージョン ID>.geul`([公表アドレスとバージョン一覧](../publishing.md#목록-문서))。何の一覧かはレコードの DOC-POINTER が語る。一覧ドキュメントのバージョンは、その `versions.geul` の PUBLICATION が DOC-POINTER(`0x00000000`、予約ドキュメント ID、バージョン ID)で指す。コンテンツハッシュアドレス `<Issuer>/hashes/` は上記ドキュメントの写しなので、原本に従う。
- ドキュメント ID `0xFFFFFFFFFFFFFFFF` はすべての Issuer で予約されており(`0x0000000000000000` も同じ)、Issuer `0x00000000` の Issuer 一覧に使う。他の Issuer は使わない。一覧ドキュメントには `DOC-ID` がないので、この値は `issuers/versions.geul` レコードの DOC-POINTER にのみ現れる。
- Codec 規格ドキュメントは GEUL Issuer `0x00000000` の Codec ドキュメントである。ドキュメント ID がなく、`DOC-ID` として CODEC-POINTER(`0x00000000`、Codec ID、`0`)を置く。Codec ID は Kind·Codec の TAG WORD を 32 ビットで表した値である(`0x0B80` → `0x00000B80`)([規格ドキュメント](../codec-spec.md))。

## 例 {#예시}

- Issuer `0x00000002`、ドキュメント `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (Meta TAG 1 + Reference TAG 1 + Issuer 2 + ドキュメント ID 4 + バージョン 2 = 10 WORD)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001C70/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
