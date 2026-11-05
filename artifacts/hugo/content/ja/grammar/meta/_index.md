---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta は世界についての内容ではなく、ドキュメントについてのレコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta は世界についての内容ではなく、ドキュメントについてのレコードである。ドキュメント構造レコード(DOC・BODY・END)を除き、すべてドキュメントの HEAD に置く。HEAD には Meta のほかに、ドキュメント全体の根拠 Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)とその QUALIFIER も来る。

## レイアウト {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      セクション 14・15 (0x1C0L~0x1FFL)
[Length 拡張 TAG]
Payload           生値、または埋め込み Value・Reference レコード
```

- Meta には Issuer 形式がない。Meta はすべての Issuer が従う共通規格であり、GEUL のみが定義する。
- `LLLL` は TAG WORD を含む全体の WORD 数 − 1 である。表にない Codec は Reserved である。

## Payload 形式 {#payload-형식}

| 形式 | いつ | 例 |
|---|---|---|
| 生値 | 形式が 1 つに定まるとき。他のレコード Codec に依存しない | `DOC-*` の長さ、`SPEC-VERSION`、`ISSUER-KEY` |
| 埋め込み Value | 複数の形式から選ぶとき。Value TAG が形式を知らせる | `PROFILE`、`EFFECTIVE-*`、時刻、コンテンツハッシュ |
| 埋め込み Reference | 人・組織・ツール・ドキュメントのような対象を指すとき | `DOC-ID`、`AUTHOR`、`CO-AUTHOR`、`RECORDED-BY`、`SIGNED-OFF`、`SIGNATURE` の署名者 |
| なし | 1 WORD のマーカー | `BODY`、`END` |

- 埋め込みレコードは独立したレコードではなく、その Meta に属する。それぞれが Length で境界を見つけ、最後のレコードを読み終えた位置が Meta の末尾とちょうど一致しなければならない。
- 1 つのドキュメントに 1 つだけ置ける Meta と複数置ける Meta は、各 Codec ドキュメントの「個数」が定める。

## クラス {#클래스}

Meta の番号は `0x1C0L` から Reserved なしで続く。番号のビットはクラスを表さない。クラスは下の区間表で知る。

| クラス | 直接コード | 扱うもの |
|---|---|---|
| 構造 | `0x1C0L~0x1C4L` | ドキュメントの境界と長さ |
| 定義 | `0x1C5L~0x1CAL` | 解釈の宣言 |
| 出典 | `0x1CBL~0x1D0L` | 誰が、いつ、どこで |
| 系譜 | `0x1D1L~0x1DDL` | 何からどのようにして生まれたか |
| ポリシー | `0x1DEL~0x1E3L` | どのように取り扱うか |
| IMPORT | `0x1E4L` | 外部ドキュメントを取り込む |
| 検証 | `0x1E5L~0x1E9L` | 信頼できるか |
| Reserved(検証専用) | `0x1EAL~0x1FFL` | |

- 検証クラスは、セクション 15 で `C >= 5`、すなわち `w >= 0x1E50` のレコードである。Codec ブックなしでこれにより検証クラスを知り、コンテンツハッシュから除く。
- 後ろの Reserved `0x1EAL~0x1FFL` は検証専用である。検証以外の新しい Meta は検証より前に入れられず、後ろの Reserved に置くとコンテンツハッシュから除かれる。
- 構造・定義・IMPORT クラスはビットで読まない。デコーダは組み込みの番号表で知る。
- **解釈に必要な Meta**: 構造、定義、IMPORT。消すとレコードを読めなくなるか、解釈が変わる。すべてのデコーダが処理しなければならない。これらの Codec は **GEUL コア Codec ブック**に属する。
- **解釈を変えない Meta**: 出典、系譜、検証、ポリシー。消しても叙述の内容はそのままである。信頼判断と取り扱いの材料だけが失われる。
- 根拠は Meta ではなく根拠 Edge [SOURCE](../edge/0x0C0L-source.md)と QUALIFIER で書く。個別レコードの根拠は BODY に、ドキュメント全体の原典は HEAD に Target `0` の SOURCE として置く([ドキュメント](../document.md#head와-body))。

## 構造 {#구조}

Meta の構造クラス(Codec `0x1C0L~0x1C4L`)は、ドキュメントの境界と長さを定める。GEUL データの単位はドキュメント 1 つである。

```
DOC-*                  ← HEAD 開始
  定義・出典・系譜・検証・ポリシー・IMPORT Meta
  ドキュメント全体の SOURCE とその QUALIFIER
BODY                   ← BODY 開始
  Reference, Value, Edge
END                    ← ドキュメントを閉じる
```

- すべてのドキュメントは `DOC-1WORD/2WORD/4WORD` で全体の長さを指定して開く。デコーダはこの長さでドキュメント全体を一度に読み飛ばせる。
- `BODY` と `END` は Payload のない 1 WORD レコードである。`END` は必須である。
- ドキュメントは入れ子にしない。他のドキュメントは IMPORT で指す。
- HEAD(Meta、ドキュメント全体の SOURCE とその QUALIFIER)が空なら `BODY` を省略する。`BODY` はドキュメントごとに 1 回だけ置ける。

ドキュメント構造の全体は[ドキュメント](../document.md)にある。

| Codec | 名前 | 意味 |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | 全体の長さを指定してドキュメントを開く |
| `0x1C3L` | [BODY](0x1C3L-body.md) | HEAD を終えて BODY を開く |
| `0x1C4L` | [END](0x1C4L-end.md) | ドキュメントを閉じる |

詳しい規則は[ドキュメント](../document.md)にある。

## 定義 {#정의}

Meta の定義クラス(Codec `0x1C5L~0x1CAL`)は解釈の宣言である。宣言は解釈規則を変えるので、すべてのデコーダが処理しなければならない。宣言の範囲はそのドキュメントである。

- `SPEC-VERSION` は残りのレコードをどう読むかを定めるので、埋め込み Value なしで整数のみを置く。GEUL v1 は `0x0001`(レコード `1C51 0001`)である。
- `DOC-ID` は、そのドキュメント自身を指す `DOC-POINTER`(Issuer、ドキュメント ID、バージョン `0`)である。Codec ドキュメントは `CODEC-POINTER`(Issuer、Codec ID、バージョン `0`)である。なければ名前のないドキュメントであり、コンテンツハッシュでのみ指せる。
- ドキュメント名のアドレスはない。人が読むタイトルは叙述 `LABEL` で付ける([公表アドレスとバージョン一覧](../publishing.md#문서-이름))。

| Codec | 名前 | 意味 |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | 従う仕様の版。整数 1 つ |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | 適用プロファイル |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | このドキュメントの識別子。自分自身を指す DOC-POINTER(バージョン 0)。Codec ドキュメントは CODEC-POINTER(バージョン 0) |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | このバージョンの施行日。なければ公表時刻 |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | このバージョンの有効期間の終わり(限時法)。なければ次のバージョンが施行されるまで |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | 既定言語 |

- ドキュメント名のアドレスはない([公表アドレスとバージョン一覧](../publishing.md#문서-이름))。人が読むタイトルは BODY の LABEL で付ける。

## 出典 {#출처}

Meta の出典クラス(Codec `0x1CBL~0x1D0L`)は、ドキュメントを誰が、いつ作成し記録したかを記す。

- 作成者・記録者とその時刻は、git の author・committer モデルに従う(`AUTHOR`・`CREATED-AT`、`RECORDED-BY`・`RECORDED-AT`)。
- 出典は消しても叙述の内容は変わらない。信頼判断の材料だけが失われる。
- 原典資料はこのクラスにない。ドキュメント全体の原典は HEAD に、個別レコードの原典は BODY に、根拠 Edge [SOURCE](../edge/0x0C0L-source.md)として書く。原文内の対応範囲、取得時刻、原文ハッシュは、その SOURCE に付く QUALIFIER である(ページ P304・節 P958、参照日 P813、チェックサム P4092)。
- 原典に付随する性質(原文の範囲、取得時刻)を Meta に置くと、原典が複数ある場合にどの原典のものか定められない。そのため SOURCE を Target とする QUALIFIER で書く。

| Codec | 名前 | 意味 |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | 作成者 (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | 共同作成者 |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | 作成時刻 |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | 修正時刻 |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | 記録した主体 |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | 記録した時刻 |

- 原典資料は Meta ではなく、HEAD の根拠 Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)(Target `0`)で書き、原文の範囲・取得時刻・原文ハッシュは、その SOURCE に付く QUALIFIER で書く。

## 系譜 {#계보}

Meta の系譜クラス(Codec `0x1D1L~0x1DDL`)は、ドキュメントが何からどのようにして生まれたかを記す。系譜は git のコミットモデルに従い、コミットに当たる単位がドキュメントである。

- **コンテンツハッシュ**はドキュメント一式の内容を指す(git commit id)。開くレコード(`DOC-*`)から `END` の直前までの SHA-256 であり、検証クラス(セクション 15 の `C >= 5`、`w >= 0x1E50`)のレコードは計算から除く。
- **バージョン ID** は、名前のあるドキュメントの中で公表順に 1 から振る 2 WORD の整数である。`0` はバージョンを記していないという意味である。
- 系譜 Meta はコンテンツハッシュでバージョンを指す。ドキュメント内の `PARENT` もハッシュに入るので、コンテンツハッシュは履歴全体をつなぐハッシュチェーンになる。
- 履歴は消さない。直した内容は新しいバージョンとして出す。branch のように変わるポインタはドキュメントに置かない。
- `DELTA-BASE`・`DELTA-REMOVE` は、バージョンを基準バージョンに対する diff として保存する形式である。バージョンは常にスナップショットとして定義する。

改訂規則は[ドキュメント](../document.md)にある。

系譜は git のコミットモデルに従う。コミットに当たる単位がドキュメントである。

| Codec | 名前 | 意味 |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | 直前のバージョンのコンテンツハッシュ。複数ならマージ |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | 別の系譜の資料から派生 |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | 生成主体(人、モデル、ルールエンジン) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | 変換ツールとそのソースバージョン(コミットダイジェスト) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | 取り込んだ変更の元のバージョン |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | 元に戻した対象バージョン |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | 書き直した対象バージョン。元のバージョンは消さない |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | 一つにまとめた元のバージョン群 |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | 変更の理由。言語ごとに 1 つ |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | バージョンに付けた不変の名前 |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | このファイルは基準バージョンに対する diff である |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | diff から除く LOCAL ID の一覧 |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | 次に割り当てる LOCAL ID。バージョン一覧ドキュメントに置く |

- 履歴は消さない。直した内容は新しいバージョンとして出す。
- branch のように変わるポインタはドキュメントに置かない。リポジトリと索引が管理する。

## 検証 {#검증}

Meta の検証クラス(Codec `0x1E5L~0x1E9L`)は、ドキュメントを信頼できるかを判断する材料を記す。自己発行 Issuer の公開鍵、署名、貢献の権利の確認、信頼度、ドキュメント全体の判定結果である。

- 検証クラスはコンテンツハッシュの計算から除かれる。そのため署名をドキュメントの中に置いても、署名を複数加えても、コンテンツハッシュは変わらない(git `gpgsig` と同じ方式)。
- 検証クラスはセクション 15 で `C >= 5`、すなわち `w >= 0x1E50` のレコードなので、Codec ブックなしでハッシュを計算できる。後ろの Reserved `0x1EAL~0x1FFL` も検証専用なのでハッシュから除かれる。
- ノード・レコード単位の判定は [TOULMIN](../toulmin/_index.md) Edge `VERDICT`(`0x118L`)が担う。

| Codec | 名前 | 意味 |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | 自己発行 Issuer の署名アルゴリズムと公開鍵 |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | コンテンツハッシュに対する署名。アルゴリズム、署名者、署名 |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | 貢献の権利の確認 |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | 信頼度 |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | ドキュメント全体の判定結果(Pass、Review、Fail) |

- 検証クラスはコンテンツハッシュの計算から除かれる。そのため署名をドキュメントの中に置いても、署名を複数加えても、コンテンツハッシュは変わらない。

## ポリシー {#정책}

Meta のポリシークラス(Codec `0x1DEL~0x1E3L`)は、ドキュメントをどう取り扱うかを定める。ライセンス、公開範囲、個人情報等級、保存期限、同意、使用制限である。

- ポリシーは解釈を変えず、取り扱い方法を定める。
- バイト列内の著作物の元のライセンスは `LICENSE` で記録する。

| Codec | 名前 | 意味 |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | ライセンス |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | 公開範囲 |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | 個人情報等級 |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | 保存期限 |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | 同意の範囲と根拠 |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | 使用制限 |

- ポリシーは解釈を変えず、取り扱い方法を定める。

## IMPORT {#import}

Meta の IMPORT クラス(Codec `0x1E4L`)は、外部ドキュメントを IMPORT ID で取り込む。Codec は `IMPORT-DOC`(`0x1E4L`)1 つである。

- IMPORT はドキュメントだけを取り込む。取り込んだドキュメント内の対象は、BODY の Reference `EXTERNAL-POINTER-*`(IMPORT ID、LOCAL ID)で指す([Reference](../reference/_index.md))。
- バージョン ID を記せばその版に、`0` なら解釈時点の最新の版にバインドされる。公表ドキュメントはバージョンを記す。
- 取り込んだドキュメントの HEAD は取り込まない。Reference・Value レコードは取り込まずコピーする。

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[Length 拡張 TAG]
ドキュメント      DOC-POINTER レコード (Issuer、ドキュメント ID、バージョン ID)。Codec ドキュメントは CODEC-POINTER
IMPORT ID         残り。最も短い幅の整数
```

- [IMPORT-DOC](0x1E4L-import-doc.md)(`0x1E4L`)だけを使う。IMPORT はドキュメントだけを取り込む。取り込んだドキュメント内の対象は、BODY の `EXTERNAL-POINTER-*`(IMPORT ID、LOCAL ID)で指す。
- バージョン ID を記せばその版に、`0` なら解釈時点の最新の版にバインドされる。公表ドキュメントはバージョンを記す。
- 1 つのドキュメントで同じ IMPORT ID を 2 回割り当てない。
- 取り込んだドキュメントの HEAD は取り込まない。そのドキュメントの対象は、そのドキュメントの宣言どおりに解釈する。

例: Issuer `0x00000002` のドキュメント `0x0000000000000002` の最新バージョンを IMPORT ID 1 として取り込む。

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
