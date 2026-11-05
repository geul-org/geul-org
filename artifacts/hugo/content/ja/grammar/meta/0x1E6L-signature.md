---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ドキュメントのコンテンツハッシュに対する署名である(git の署名コミット・タグ)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SIGNATURE` (規格ドキュメント BIND `SIGNATURE`) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E60/` (DECLARE 対象 `1E60`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 6 |
| Kind | Meta · クラス: 検証 |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 対象に対する署名。ドキュメントに対する署名はコンテンツハッシュに署名する (git の署名コミット・タグ) |
| Hugo 側 | `meta/verification/signature.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | 生値 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | レコード | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | 残り生値(`0xFFFF`) |  |  |

ドキュメントのコンテンツハッシュに対する署名である(git の署名コミット・タグ)。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[Length 拡張 TAG]
アルゴリズム ID   1 WORD (0x0001 = Ed25519)
署名者            ISSUER-POINTER(Issuer) Reference レコード
署名              残りすべて。幅はアルゴリズムが定める (Ed25519 32 WORD)
```

- Codec: Meta `0x1E6L`、検証クラス
- Payload: アルゴリズム ID(生値 1 WORD)+ 署名者(埋め込み Reference)+ 署名(生値、残り)
- 個数: 複数可

## 解釈と有効性 {#해석과-유효성}

- 署名の対象はコンテンツハッシュである。BODY だけに署名しない([署名](../issuer.md#서명))。
- 検証クラスなのでコンテンツハッシュから除かれる。署名を加えてもハッシュは同じである。
- 「署名があれば確認する」ではなく、「定められた鍵の署名がなければならない」として検証する。
- バージョン一覧ドキュメントは公表元が署名する。
- 署名者は Issuer 自身を指す [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)(Issuer)である。Reference レコードなので自身の Length で終わるため、署名の幅がアルゴリズムごとに異なってもレイアウトが 1 つに定まる([DECLARE](../edge/0x0BBL-declare.md) の残りフィールド)。
- 署名の WORD 数がアルゴリズムの定める幅と異なれば invalid である。

## 未解決の問題 {#열린-문제}

- 署名時刻も併せて署名するか。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E60/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
