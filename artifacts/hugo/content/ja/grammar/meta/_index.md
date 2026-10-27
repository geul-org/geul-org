---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta は世界ではなくドキュメントに関するレコードだ。構造・定義・出典・系譜・検証・ポリシー・IMPORT の七つのクラスに分かれ、ドキュメントの HEAD に置く。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta は、世界についての内容ではなく、ドキュメントに関するレコードだ。ドキュメント構造レコード(DOC・BODY・END)を除けば、すべてドキュメントの HEAD に置く。HEAD には Meta のほかに、ドキュメント全体の根拠 Edge [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)とその QUALIFIER も来る。

## レイアウト

```
TAG WORD          0001 1LLL LCCC CCCC
[Length 拡張 TAG]
Payload           生値または組み込みの Value・Reference レコード
```

- Meta には Issuer 形式がない。Meta はすべての Issuer が従う共通規格で、GEUL だけが定義する。
- `LLLL` は TAG WORD を含む全 WORD 数 − 1 だ。表にない Codec は予約だ。

## Payload 形式

| 形式 | いつ | 例 |
|---|---|---|
| 生値 | 形式が一つに決まるとき。他のレコード Codec に依拠しない | `DOC-*` の長さ、`SPEC-VERSION`、`ISSUER-KEY` |
| 組み込み Value | 複数の形式から選ぶとき。Value TAG が形式を知らせる | `PROFILE`、`EFFECTIVE-*`、時刻、コンテンツハッシュ |
| 組み込み Reference | 人・組織・ツール・ドキュメントのような対象を指すとき | `DOC-ID`、`AUTHOR`、`CO-AUTHOR`、`RECORDED-BY`、`SIGNED-OFF`、`SIGNATURE` の署名者 |
| なし | 1 WORD マーカー | `BODY`、`END` |

- 組み込みレコードは独立したレコードではなく、その Meta に属する。それぞれの Length で境界を見つけ、最後のレコードを読み終えた位置が Meta の終わりとちょうど合わなければならない。
- 一つのドキュメントに一つだけ置ける Meta と、複数置ける Meta は、各 Codec ドキュメントの「個数」が決める。

## クラス

Codec の上位3ビットがクラスだ。

| 上位3ビット | クラス | 直接コード | 扱うもの |
|---|---|---|---|
| `000` | 構造 | `0x00`~`0x0F` | ドキュメントの境界と長さ |
| `001` | 定義 | `0x10`~`0x1F` | 解釈の宣言 |
| `010` | 出典 | `0x20`~`0x2F` | 誰が、いつ、どこで |
| `011` | 系譜 | `0x30`~`0x3F` | 何からどのように出てきたか |
| `100` | 検証 | `0x40`~`0x4F` | 信頼できるか |
| `101` | ポリシー | `0x50`~`0x5F` | どう取り扱うか |
| `110` | IMPORT | `0x60`~`0x6F` | 外部ドキュメントを取り込む |
| `111` | 予約 | `0x70`~`0x7F` | |

- **解釈に必要な Meta**: 構造、定義、IMPORT。消すとレコードが読めなくなるか、解釈が変わる。すべてのデコーダが処理しなければならない。これらの Codec は **GEUL 中核コードブック**に属する。
- **解釈を変えない Meta**: 出典、系譜、検証、ポリシー。消しても記述の内容はそのままだ。信頼判断と取り扱いの材料だけが失われる。
- 根拠は Meta ではなく、根拠 Edge [SOURCE](/ja/grammar/edge/source/) と QUALIFIER で書く。個々のレコードの根拠は BODY に、ドキュメント全体の原典は HEAD に Target `0` の SOURCE として置く([ドキュメント](/ja/grammar/document/#head-と-body))。

## 構造

まとまりドキュメント: [Meta — 構造](/ja/grammar/meta/structure/)

| Codec | 名前 | 意味 |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/ja/grammar/meta/structure/doc/) | 全体の長さを指定してドキュメントを開く |
| `0x0E` | [BODY](/ja/grammar/meta/structure/body/) | HEAD を終えて BODY を開く |
| `0x0F` | [END](/ja/grammar/meta/structure/end/) | ドキュメントを閉じる |

詳しい規則は[ドキュメント](/ja/grammar/document/)にある。

## 定義

まとまりドキュメント: [Meta — 定義](/ja/grammar/meta/declaration/)

| Codec | 名前 | 意味 |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ja/grammar/meta/declaration/spec-version/) | 従う仕様の版。整数一つ |
| `0x11` | [PROFILE](/ja/grammar/meta/declaration/profile/) | 適用プロファイル |
| `0x12` | [DOC-ID](/ja/grammar/meta/declaration/doc-id/) | このドキュメントの識別子。自分自身を指す DOC-POINTER(バージョン 0) |
| `0x13` | [EFFECTIVE-FROM](/ja/grammar/meta/declaration/effective-from/) | このバージョンの施行日。なければ公表時刻 |
| `0x14` | [EFFECTIVE-UNTIL](/ja/grammar/meta/declaration/effective-until/) | このバージョンの有効期間の終わり(限時法)。なければ次のバージョンが施行されるまで |
| `0x16` | [DEFAULT-LANGUAGE](/ja/grammar/meta/declaration/default-language/) | 既定の言語 |

- ドキュメントのアドレス用の名前は Meta に置かない。Issuer の名前索引 `documents.geul` が BIND で付ける([公表アドレスとバージョン一覧](/ja/grammar/publishing/#ドキュメント名))。人が読むタイトルは BODY の LABEL で付ける。

## 出典

まとまりドキュメント: [Meta — 出典](/ja/grammar/meta/provenance/)

| Codec | 名前 | 意味 |
|---|---|---|
| `0x20` | [AUTHOR](/ja/grammar/meta/provenance/author/) | 作成者 (Reference) |
| `0x21` | [CO-AUTHOR](/ja/grammar/meta/provenance/co-author/) | 共同作成者 |
| `0x22` | [CREATED-AT](/ja/grammar/meta/provenance/created-at/) | 作成時刻 |
| `0x23` | [MODIFIED-AT](/ja/grammar/meta/provenance/modified-at/) | 修正時刻 |
| `0x24` | [RECORDED-BY](/ja/grammar/meta/provenance/recorded-by/) | 記録した主体 |
| `0x25` | [RECORDED-AT](/ja/grammar/meta/provenance/recorded-at/) | 記録した時刻 |
| `0x26`~`0x2F` | Reserved | |

- 原典資料は Meta ではなく、HEAD の根拠 Edge [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)(Target `0`)で書き、原文範囲・入手時刻・原文ハッシュは、その SOURCE に付く QUALIFIER で書く。

## 系譜

まとまりドキュメント: [Meta — 系譜](/ja/grammar/meta/lineage/)

系譜は git のコミットモデルに従う。コミットに当たる単位がドキュメントだ。

| Codec | 名前 | 意味 |
|---|---|---|
| `0x30` | [PARENT](/ja/grammar/meta/lineage/parent/) | 直前バージョンのコンテンツハッシュ。複数ならマージ |
| `0x31` | [DERIVED-FROM](/ja/grammar/meta/lineage/derived-from/) | 他の系譜の資料から派生 |
| `0x32` | [GENERATED-BY](/ja/grammar/meta/lineage/generated-by/) | 生成した主体(人、モデル、ルールエンジン) |
| `0x33` | [TRANSFORMED-BY](/ja/grammar/meta/lineage/transformed-by/) | 変換ツールとそのソースバージョン(コミットダイジェスト) |
| `0x34` | [CHERRY-PICKED-FROM](/ja/grammar/meta/lineage/cherry-picked-from/) | 取り込んだ変更の元のバージョン |
| `0x35` | [REVERTS](/ja/grammar/meta/lineage/reverts/) | 取り消した対象バージョン |
| `0x36` | [REPLACES](/ja/grammar/meta/lineage/replaces/) | 書き直した対象バージョン。元のバージョンは消さない |
| `0x37` | [SQUASHED-FROM](/ja/grammar/meta/lineage/squashed-from/) | 一つにまとめた元のバージョン群 |
| `0x38` | [MESSAGE](/ja/grammar/meta/lineage/message/) | 変更の理由。言語ごとに一つ |
| `0x39` | [TAG](/ja/grammar/meta/lineage/tag/) | バージョンに付けた不変の名前 |
| `0x3A` | [DELTA-BASE](/ja/grammar/meta/lineage/delta-base/) | このファイルは基準バージョンに対する diff だ |
| `0x3B` | [DELTA-REMOVE](/ja/grammar/meta/lineage/delta-remove/) | diff で除く LOCAL ID の一覧 |
| `0x3C` | [NEXT-LOCAL-ID](/ja/grammar/meta/lineage/next-local-id/) | 次に割り当てる LOCAL ID。バージョン一覧ドキュメントに置く |

- 履歴は消さない。直した内容は新しいバージョンとして出す。
- branch のように変わるポインタは、ドキュメントに置かない。ストアとインデックスが管理する。

## 検証

まとまりドキュメント: [Meta — 検証](/ja/grammar/meta/verification/)

| Codec | 名前 | 意味 |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ja/grammar/meta/verification/issuer-key/) | 自己発行 Issuer の署名アルゴリズムと公開鍵 |
| `0x41` | [SIGNATURE](/ja/grammar/meta/verification/signature/) | コンテンツハッシュに対する署名。アルゴリズム、署名者、署名 |
| `0x42` | [SIGNED-OFF](/ja/grammar/meta/verification/signed-off/) | 寄与の権利の確認 |
| `0x43` | [CONFIDENCE](/ja/grammar/meta/verification/confidence/) | 信頼度 |
| `0x44` | [VERDICT](/ja/grammar/meta/verification/verdict/) | ドキュメント全体の判定結果(Pass、Review、Fail) |

- 検証クラスはコンテンツハッシュの計算から除かれる。そのため署名をドキュメント内に置いても、署名を複数加えても、コンテンツハッシュは変わらない。

## ポリシー

まとまりドキュメント: [Meta — ポリシー](/ja/grammar/meta/policy/)

| Codec | 名前 | 意味 |
|---|---|---|
| `0x50` | [LICENSE](/ja/grammar/meta/policy/license/) | ライセンス |
| `0x51` | [ACCESS](/ja/grammar/meta/policy/access/) | 公開範囲 |
| `0x52` | [PRIVACY](/ja/grammar/meta/policy/privacy/) | 個人情報の等級 |
| `0x53` | [RETENTION](/ja/grammar/meta/policy/retention/) | 保存期限 |
| `0x54` | [CONSENT](/ja/grammar/meta/policy/consent/) | 同意の範囲と根拠 |
| `0x55` | [USAGE](/ja/grammar/meta/policy/usage/) | 使用制限 |

- ポリシーは解釈を変えず、取り扱い方法を定める。

## IMPORT

まとまりドキュメント: [Meta — IMPORT](/ja/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length 拡張 TAG]
ドキュメント      DOC-POINTER レコード (Issuer, ドキュメント ID, バージョン ID)
IMPORT ID         残り。最短幅の整数
```

- [IMPORT-DOC](/ja/grammar/meta/import/import-doc/)(`0x60`)一つだけを使う。IMPORT はドキュメントだけを取り込む。取り込んだドキュメント内の対象は、BODY の `EXTERNAL-POINTER-*`(IMPORT ID、LOCAL ID)で指す。
- バージョン ID を書けばその版に、`0` なら解釈時点の最新の版に結びつく。公表ドキュメントはバージョンを書く。
- 一つのドキュメントで同じ IMPORT ID を二度割り当てない。
- 取り込んだドキュメントの HEAD は取り込まない。そのドキュメントの対象は、そのドキュメントの宣言どおりに解釈する。

例: Issuer `0x0001` のドキュメント `0x0000000000000002` の最新バージョンを IMPORT ID 1 で取り込む。

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
