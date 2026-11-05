---
title: "TOMBSTONE (0x0BAL)"
weight: 186
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION・DEPRECATION・TOMBSTONE は、ドキュメントバージョンの公表・使用中止の勧告・削除を記録する叙述 Edge であり、このページはその Edge で書くバージョン一覧ドキュメントの規格も定める(Codec 0x0B8L~0x0BAL)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION・DEPRECATION・TOMBSTONE は、ドキュメントバージョンの公表・使用中止の勧告・削除を記録する叙述 Edge であり、このページはその Edge で書くバージョン一覧ドキュメントの規格も定める(Codec 0x0B8L~0x0BAL)。

| 項目 | 値 |
|---|---|
| 名前 | `TOMBSTONE` (規格ドキュメント BIND `TOMBSTONE`) |
| TAG ID | `0x0BAL` |
| Codec ID | `0x00000BA0` |
| 規格ドキュメント | `0x00000000/codecs/0x00000BA0/` (DECLARE 対象 `0BA0`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 26 |
| Kind | Edge · 系列: 叙述、まとまり: その他 |
| TAG WORD | `0000 1011 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 公表したバージョンの削除(墓標)。DOC-POINTER、理由区分 |
| Hugo 側 | `edge/publication.md` (そちらは [PUBLICATION](0x0B8L-publication.md)、[DEPRECATION](0x0B9L-deprecation.md) もあわせて扱う) |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | レコード | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `reason` | #4 | 生値 1 WORD |  |  |

ドキュメントの公表・deprecate・削除を記録する叙述 Edge と、その Edge で書くバージョン一覧ドキュメントの規格である。[公表アドレスとバージョン一覧](../publishing.md#버전-목록)のバージョン一覧の形式を定める。

## コード {#코드}

| Codec | 名前 | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, コンテンツハッシュ |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, 理由区分 |

- 三つのコードはデコーダに内蔵する([0 層](../publishing.md#층))。バージョン一覧はコードブックを参照せずに解釈される。
- 下位形式(Codec ごとの TAG)は置かない。Payload の最初の要素が Edge Id であるという [Edge](_index.md) の規則をそのまま守る。

## レイアウト {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
ドキュメント      DOC-POINTER Reference レコード (Issuer, ドキュメント ID, バージョン ID)。Codec のバージョン一覧は CODEC-POINTER
コンテンツハッシュ  16 WORD   (PUBLICATION)
理由区分          1 WORD    (TOMBSTONE)
```

| フィールド | 幅 | 説明 |
|---|---|---|
| Edge Id | LOCAL Reference レコード | 一覧内の通し番号。1 から振り、続けて付ける |
| ドキュメント | DOC-POINTER レコード | 公表したドキュメントの一つのバージョン([DOC-POINTER](../reference/0x041L-doc-pointer.md))。Issuer・ドキュメント ID はその一覧が扱うドキュメントと同じである。一覧ドキュメントが、パスなしでも何の一覧かを語れるようにする。バージョン ID はそのドキュメント内の通し番号([ドキュメント](../document.md)のバージョン)であり、`0`(最新)は使わない。Codec のバージョン一覧は [CODEC-POINTER](../reference/0x042L-codec-pointer.md)(Issuer, Codec ID, バージョン ID)を使う |
| コンテンツハッシュ | 16 WORD | そのバージョンのコンテンツハッシュ(SHA-256、[ドキュメント](../document.md)のコンテンツハッシュ) |
| 理由区分 | 1 WORD | 削除理由の区分コード。コード表は未解決の問題である |

- DOC-POINTER の後の長さはコードごとに固定である(16、0、1 WORD)。異なれば拒否する。
- 時刻はレコードに入れない。そのレコードが最初に載った一覧ドキュメントの `RECORDED-AT` が、公表・deprecate・削除の時刻である。

## バージョン一覧ドキュメント {#버전-목록-문서}

公表先はドキュメントごとにバージョン一覧ドキュメント一つを書き継ぐ: `/<Issuer>/docs/<ドキュメント ID>/versions.geul`(Codec は `/<Issuer>/codecs/<Codec ID>/versions.geul`、Issuer 一覧は[下記](#목록-문서의-버전-목록))。そのドキュメントがその公表先で公表されたすべてのバージョンが一つの一覧に入る。

```
DOC-1WORD/2WORD/4WORD     全体の長さ
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value。直前の一覧ドキュメントのコンテンツハッシュ (最初の一覧ならなし)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value。この一覧を出した時刻
  NEXT-LOCAL-ID           次に割り当てる LOCAL ID (バージョンがあれば)
  SIGNATURE               公表先の署名。対象はこの一覧ドキュメントのコンテンツハッシュ
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- HEAD Meta: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- バージョン一覧ドキュメントには `DOC-ID` を置かない(一覧ドキュメントの例外、[DOC-ID](../meta/0x1C7L-doc-id.md))。一覧は公表ドキュメントではなく、そのドキュメントに付随する記録である。どのドキュメントの一覧かは、レコードの DOC-POINTER(ドキュメント ID)が語る。そのため、パスなしで(`hashes/`、ダンプ)受け取っても何の一覧か分かる。
- レコードのドキュメント ID は、すべてその一覧が扱うドキュメントでなければならない。別のドキュメントのレコードは拒否する。
- バージョン一覧ドキュメントは IMPORT を置かず、0 層の Codec だけを使う。BODY には PUBLICATION・DEPRECATION・TOMBSTONE だけを置く。ドキュメント名の BIND は置かない([公表アドレスとバージョン一覧](../publishing.md#문서-이름))。
- 新しい一覧ドキュメントは、直前の一覧ドキュメントの BODY をそのまま前に置き、レコードを付け足す。直したり消したり順序を変えたりしない。
- 公表先が一覧に署名する。geul.org の公表は geul.org(GEUL Issuer)が、私的な公表はその Issuer が署名する。
- ドキュメント ID `0x0000000000000000` は Issuer の用語定義の索引ドキュメントである([Issuer と公表](../issuer.md))。Issuer 自身は [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) で指す。

## 一覧ドキュメントのバージョン一覧 {#목록-문서의-버전-목록}

一覧ドキュメントは Issuer 一覧 `issuers/` 一つである([公表アドレスとバージョン一覧](../publishing.md#목록-문서))。Issuer 一覧もバージョン 1 から始まり、バージョン一覧 `issuers/versions.geul` を置く。レコードは予約ドキュメント ID の DOC-POINTER(`0x00000000`、`0xFFFFFFFFFFFFFFFF`、バージョン ID)で一覧のバージョンを指す。

- レコードの形式は上と同じである。そのため `hashes/` で受け取っても何の一覧か分かる。
- 一覧ドキュメント自身(`<バージョン ID>.geul`)も `DOC-ID` を置かない。
- ドキュメント ID `0xFFFFFFFFFFFFFFFF` は、どの Issuer でも `<Issuer>/docs/<ドキュメント ID>/` のアドレスでは受け付けない(404)。
- 一覧の `latest.geul` は保存しないエイリアスである。このバージョン一覧から最も新しいバージョンを探して、そのバイト列を出す。

## 規則 {#규칙}

- PUBLICATION のバージョン ID は 1 から欠番なく昇順である。バージョン ID は公表先が割り当てる。
- 同じコンテンツハッシュを再び公表しない。すでにあれば、そのバージョン ID を返す。
- DEPRECATION・TOMBSTONE は、前に出た PUBLICATION のバージョン ID だけを指す。存在しないバージョンを指せば拒否する。
- バージョンの状態は、レコードを順に適用して計算する。公表済み → deprecated → 削除済み。削除されたバージョンは再び公表せず、提供しない。
- 最新バージョンは、deprecated でも削除済みでもない最も高いバージョン ID である。
- バージョン ID が 2 WORD の終端に達したら、そのドキュメントはそれ以上公表せず、新しいドキュメント ID で出す。

## アドレス {#주소}

```
/.well-known/geul/<Issuer>/docs/<ドキュメント ID>/versions.geul        最新の一覧ドキュメント (可変)
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul             Codec の最新の一覧ドキュメント (可変)
/.well-known/geul/issuers/versions.geul                       Issuer 一覧の最新のバージョン一覧 (可変)
/.well-known/geul/<Issuer>/hashes/<コンテンツハッシュ>.geul             過去の一覧ドキュメント (不変)
```

- 可変なのは最新の一覧アドレスである。受け取った一覧は、署名、`RECORDED-AT`、`PARENT` チェーンで検証する。
- 過去の一覧ドキュメントはすべて `<Issuer>/hashes/` に残す。`PARENT` チェーンをたどれば、どの時点の一覧でもさかのぼれる。

## 検証 {#검증}

- 一覧ドキュメントに、定められた公表先の鍵の `SIGNATURE` がなければならない。
- レコードのドキュメント ID が、要求したドキュメント ID と同じでなければならない。
- ロック記録に残った直前の一覧のコンテンツハッシュが、新しい一覧の `PARENT` チェーンになければならない。その一覧の BODY は、新しい一覧の BODY の前半部分と同じでなければならない。
- 受け取ったドキュメントのコンテンツハッシュは、そのバージョン ID の PUBLICATION が記した値と同じでなければならず、ドキュメントの `DOC-ID` は要求した Issuer・ドキュメント ID と同じでなければならない。一覧ドキュメントには `DOC-ID` がない。

## 未解決の問題 {#열린-문제}

- 理由区分のコード表。
- 署名アルゴリズムの既定値と `SIGNATURE` Payload のレイアウト。
- 一覧が大きくなったときに Merkle ログ(包含・一貫性の証明)へ移す時期と形式。
- Issuer 単位の巻き戻し防止。一覧がドキュメントごとに別のチェーンをなすので、一つのドキュメントの一覧だけを古いものとして差し出す攻撃は、そのドキュメントのチェーンでしか防げない。

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer と公表](../issuer.md), [公表アドレスとバージョン一覧](../publishing.md), [ドキュメント](../document.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000BA0/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BA000000000
BODY
#1 DECLARE 0x0BA0
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0001
#5 BIND #1 "TOMBSTONE"
#6 BIND #2 "doc"
#8 BIND #4 "reason"
#10 CODEC #2 0x0420
```
