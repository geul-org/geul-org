---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION・DEPRECATION・TOMBSTONE は、ドキュメントバージョンの公表・使用中止の勧告・削除を記録する記述 Edge で、このページはその Edge で書くバージョン一覧ドキュメントの規格も定める(Codec 0x18~0x1A)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントの公表・deprecate・削除を記録する記述 Edge と、その Edge で書くバージョン一覧ドキュメントの規格だ。[公表アドレスとバージョン一覧](/ja/grammar/publishing/#バージョン一覧)のバージョン一覧の形式を定める。

## コード

| Codec | 名前 | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, コンテンツハッシュ |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, 事由カテゴリ |

- 三つのコードはデコーダに内蔵する([0 層](/ja/grammar/publishing/#層))。バージョン一覧は、コードブックを参照せずに解釈される。
- 下位形式(Codec ごとの TAG)は置かない。Payload の最初の要素が Edge Id であるという [Edge](/ja/grammar/edge/) の規則をそのまま守る。

## レイアウト

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
ドキュメント      DOC-POINTER Reference レコード (Issuer, ドキュメント ID, バージョン ID)
コンテンツハッシュ  16 WORD   (PUBLICATION)
事由カテゴリ      1 WORD    (TOMBSTONE)
```

| フィールド | 幅 | 説明 |
|---|---|---|
| Edge Id | LOCAL Reference レコード | 一覧内の通し番号。1 から振って連ねる |
| ドキュメント | DOC-POINTER レコード | 公表したドキュメントの一バージョン([DOC-POINTER](/ja/grammar/reference/doc-pointer/))。Issuer・ドキュメント ID は、その一覧が扱うドキュメントと同じ。一覧ドキュメントが、パスがなくても何の一覧かを語れるようにする。バージョン ID はそのドキュメント内の通し番号([ドキュメント](/ja/grammar/document/)のバージョン)で、`0`(最新)は使わない |
| コンテンツハッシュ | 16 WORD | そのバージョンのコンテンツハッシュ(SHA-256、[ドキュメント](/ja/grammar/document/)のコンテンツハッシュ) |
| 事由カテゴリ | 1 WORD | 削除事由のカテゴリコード。コード表は未解決の問題 |

- DOC-POINTER の後ろの長さは、コードごとに固定だ(16、0、1 WORD)。異なれば拒否する。
- 時刻はレコードに入れない。そのレコードが最初に載った一覧ドキュメントの `RECORDED-AT` が、公表・deprecate・削除の時刻だ。

## バージョン一覧ドキュメント

公表元は、ドキュメントごとにバージョン一覧ドキュメントを一つずつ書き継ぐ: `/<Issuer>/<ドキュメント ID>/versions.geul`。そのドキュメントがその公表元で公表されたすべてのバージョンが、一つの一覧に入る。

```
DOC-1WORD/2WORD/4WORD     全体の長さ
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value。直前の一覧ドキュメントのコンテンツハッシュ (最初の一覧ならなし)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value。この一覧を出した時刻
  NEXT-LOCAL-ID           次に割り当てる LOCAL ID (バージョンがあれば)
  SIGNATURE               公表元の署名。対象はこの一覧ドキュメントのコンテンツハッシュ
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- HEAD Meta: [SPEC-VERSION](/ja/grammar/meta/declaration/spec-version/)、[PARENT](/ja/grammar/meta/lineage/parent/)、[RECORDED-AT](/ja/grammar/meta/provenance/recorded-at/)、[NEXT-LOCAL-ID](/ja/grammar/meta/lineage/next-local-id/)、[SIGNATURE](/ja/grammar/meta/verification/signature/)。
- 一覧ドキュメントには `DOC-ID` を置かない(名前が `0x` で始まらないドキュメントの例外、[DOC-ID](/ja/grammar/meta/declaration/doc-id/))。一覧は公表ドキュメントではなく、そのドキュメントに付随する記録だ。どのドキュメントの一覧かは、レコードのドキュメント ID が語る。そのためパスなしで(`h/`、ダンプ)受け取っても、何の一覧か分かる。
- レコードのドキュメント ID は、すべてその一覧が扱うドキュメントでなければならない。他のドキュメントのレコードは拒否する。
- 一覧ドキュメントは IMPORT を置かず、0 層の Codec だけを使う。他の一覧に載せない(一覧の一覧はない)。
- 新しい一覧ドキュメントは、直前の一覧ドキュメントの BODY をそのまま前に置き、レコードを書き足す。直したり、消したり、順序を変えたりしない。
- 公表元が一覧に署名する。geul.org の公表は geul.org(GEUL Issuer)が、非公開の公表はその Issuer が署名する。
- ドキュメント ID `0x0000000000000000` は、Issuer の用語定義インデックスドキュメントだ([Issuer と公表](/ja/grammar/issuer/))。Issuer 自身は [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) で指す。

## 規則

- PUBLICATION のバージョン ID は、1 から欠番なく昇順だ。バージョン ID は公表元が割り当てる。
- 同じコンテンツハッシュを再び公表しない。すでにあれば、そのバージョン ID を返す。
- DEPRECATION・TOMBSTONE は、前に出た PUBLICATION のバージョン ID だけを指す。ないバージョンを指せば拒否する。
- バージョンの状態は、レコードを順に適用して計算する。公表済み → deprecated → 削除済み。削除されたバージョンは再び公表せず、渡さない。
- 最新バージョンは、deprecated でも削除でもない最も高いバージョン ID だ。
- バージョン ID が 2 WORD の限界に達したら、そのドキュメントはそれ以上公表せず、新しいドキュメント ID で出す。

## ドキュメント名

ドキュメントのアドレス用の名前は、Issuer の名前索引 `/<Issuer>/documents.geul` が [BIND](/ja/grammar/edge/bind/) で結びつける([公表アドレスとバージョン一覧](/ja/grammar/publishing/#ドキュメント名))。リゾルバはこのインデックスだけを読む。

一覧ドキュメントにも同じ BIND を置ける(任意)。置く場合は次を守る。

- Subject は `DOC-POINTER`(Issuer、その一覧のドキュメント ID、バージョン `0`)だ。名前はバージョンではなくドキュメントに結びつくので、バージョンは `0` だ。
- 前に PUBLICATION が出たドキュメントにだけ結びつける。公表されたことのないドキュメントに名前を結びつけない。
- 名前はドキュメント名の規則(小文字 ASCII のスラッグ)に従い、名前索引の BIND と同じでなければならない。
- 名前を変えるときは、新しい BIND を書き足す。旧名はそのまま残って同じドキュメントを指す。代表名は最後の BIND だ。
- ドキュメントの中には、自分の名前を書かない。

## アドレス

```
/.well-known/geul/<Issuer>/<ドキュメント ID>/versions.geul     最新の一覧ドキュメント (可変)
/.well-known/geul/h/<コンテンツハッシュ>.geul                   過去の一覧ドキュメント (不変)
```

- 可変なのは、最新の一覧アドレス一つだけだ。受け取った一覧は、署名、`RECORDED-AT`、`PARENT` チェーンで検証する。
- 過去の一覧ドキュメントは、すべて `h/` に残す。`PARENT` チェーンをたどって、どの時点の一覧でもたどり直せる。

## 検証

- 一覧ドキュメントに、定められた公表元の鍵の `SIGNATURE` がなければならない。
- レコードのドキュメント ID が、要求したドキュメント ID と同じでなければならない。
- ロック記録に残る直前の一覧のコンテンツハッシュが、新しい一覧の `PARENT` チェーンにあるのでなければならない。その一覧の BODY は、新しい一覧 BODY の先頭部分と同じでなければならない。
- 受け取ったドキュメントのコンテンツハッシュは、そのバージョン ID の PUBLICATION が書いた値と同じでなければならず、ドキュメントの `DOC-ID` は、要求した Issuer・ドキュメント ID と同じでなければならない。

## 未解決の問題

- 事由カテゴリのコード表。
- 署名アルゴリズムの既定値と `SIGNATURE` Payload のレイアウト。
- 一覧が大きくなったときに Merkle ログ(包含・一貫性証明)へ移す時点と形式。
- 一覧の BIND と名前索引 `documents.geul` を一つに統合するか、インデックスの署名。
- Issuer 単位の巻き戻し防止。一覧がドキュメントごとに別々のチェーンをなすので、一つのドキュメントの一覧だけを古いものにして差し出す攻撃は、そのドキュメントのチェーンでしか防げない。

## 関連ページ

- [Edge](/ja/grammar/edge/)、[BIND](/ja/grammar/edge/bind/)、[DOC-POINTER](/ja/grammar/reference/doc-pointer/)
- [Issuer と公表](/ja/grammar/issuer/)、[公表アドレスとバージョン一覧](/ja/grammar/publishing/)、[ドキュメント](/ja/grammar/document/)
