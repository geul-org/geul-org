---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE は、レコード一つまたはドキュメント全体をその原典に結びつける根拠 Edge だ(Codec 0x20)。原典の性質は原典を Subject とする TRIPLE で、引用の性質(参照日、原典内の位置、原文ハッシュ)は SOURCE に付く QUALIFIER で書く。ドキュメント全体の SOURCE は HEAD に置く。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE は、レコード一つ(対象)またはドキュメント全体を、それが出てきた原典に結びつける根拠 Edge だ。Codec `0x20`。根拠系列(`01`)で唯一の直接コードだ。

Wikidata の reference(出典のまとまり)一つが SOURCE 一つだ。レコード一つに出典が複数あれば、SOURCE も複数になる。

## レイアウト

```
TAG WORD          0001 0LLL L010 0000
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Target            LOCAL Reference レコード (BODY では根拠を付ける Edge の Edge Id、HEAD では 0 = ドキュメント全体)
Origin            Reference レコード、またはプレースホルダ 0x0000 ABSENT・0x0001 UNKNOWN-VALUE
```

- Origin は原典を指す。原典に合う Reference があればそれ(WIKIDATA-QID、GEUL ドキュメントの DOC-POINTER・EXTERNAL-ISSUER など)、なければこのドキュメントの LOCAL ノードだ。
- 出典が原典を記述しない場合(例: Wikidata の "imported from"(P143)・参照日だけがある出典)、Origin は [ABSENT](/ja/grammar/reference/slot-marker/)(記載なし)だ。書き手は原典を書かなかっただけで、原典について何も断言しない。出典の残りは QUALIFIER にそのまま残る。
- 書き手が「原典はあるが何かは分からない」と断言するときだけ [UNKNOWN-VALUE](/ja/grammar/reference/slot-marker/) を使う(人が書く記録など)。原典資料から移す変換器は、原典が語っていないことを断言しないので ABSENT を使う。
- ABSENT・UNKNOWN-VALUE の Origin は、出現ごとに独立だ。二つの SOURCE の原典を同じものとして読まない。

## 二つの層

出典に関する情報は二つに分かれる。混ぜない。

| 層 | 何か | 書き方 | 例 |
|---|---|---|---|
| 原典 | 原典自体の性質。誰が引用しても同じ | 原典を Subject とする [TRIPLE](/ja/grammar/edge/triple/) (rank normal) | URL(P854)、タイトル(P1476)、著者(P50・P2093)、発行日(P577)、掲載誌(P1433)、発行元(P123)、言語(P407) |
| 引用 | このレコードが原典を引用した行為の性質 | SOURCE の Edge Id を Target とする [QUALIFIER](/ja/grammar/edge/qualifier/) | 参照日(P813)、原典内の位置(ページ P304、節 P958、外部識別子 P227・P1417)、取得元(P143)、推論方法(P887)、原文ハッシュ(P4092) |

- **SOURCE の意味は、その Edge Id を指す QUALIFIER をすべて集めたものだ。** 同じ原典を別の日に参照した二つの出典は、原典は同じで QUALIFIER が異なる。
- 原典 TRIPLE は原典についての断言だ。どちらの層か決められない性質は、引用側(QUALIFIER)に置く。原典について断言しないほうが安全だ。
- ドキュメント内で同じ原典は LOCAL 一つで一度だけ宣言し、複数の SOURCE が共に指す。
- URL 一つだけで記述される原典は [REFERENCE-NODE](/ja/grammar/edge/reference-node/)(LOCAL → URI)で定義する。sitelink のドキュメントページと同じ方式だ。

## 解釈と有効性

- Target と Origin は、それぞれちょうど一つの完全なレコードだ。Origin を読んだカーソルは Edge の終わりと一致しなければならない。
- Target は LOCAL Reference だ。BODY の SOURCE は同じドキュメント BODY の Edge Id を指す。`0`(ドキュメント全体)は HEAD の SOURCE だけが使う([ドキュメント全体の出典](#ドキュメント全体の出典))。BODY に Target `0` の SOURCE があれば invalid だ。他のドキュメントのレコードには、そのドキュメントの中で根拠を付ける。
- Origin は Reference だ。プレースホルダは `0x0000`(ABSENT)・`0x0001`(UNKNOWN-VALUE)だけを受け付ける。NO-VALUE(`0x0002`)・Value は受け付けない。
- geul.org 規格ドキュメント `0x0000/0x0000000000001020`(名前 `source`)は、Target に [CODEC](/ja/grammar/edge/codec/) LOCAL(`0008`)、Origin に CODEC `0780`(任意の Reference)・`0000`(ABSENT、任意)・`0001`(UNKNOWN-VALUE)を置く。
- 同じ Target の SOURCE 同士の順序に意味はない。出典一つの中の項目順にも意味がない(同じ属性の値の順序はドキュメント順として残る)。
- SOURCE は対象の真偽を変えない。対象がどこから来たかを書くだけだ。判定結果は [TOULMIN](/ja/grammar/edge/toulmin/) `VERDICT` が担う。

## ドキュメント全体の出典

ドキュメント全体の原典(元のダンプ、版、原文ファイル)は、**HEAD に Target `0` の SOURCE** として書く。その SOURCE を Target とする QUALIFIER(原文ハッシュ P4092、受信時刻 P813、原文範囲など)も HEAD に置く([ドキュメント](/ja/grammar/document/#head-と-body))。

- HEAD に置ける Edge はこの二つだけだ。それ以外の Edge は BODY に置く。
- HEAD の QUALIFIER は、それが指す HEAD の SOURCE の後ろに置く。デコーダは先頭から読みながら HEAD と BODY を分ける。
- HEAD の SOURCE を Target とする QUALIFIER を BODY に置くと invalid だ。BODY の SOURCE・QUALIFIER は HEAD の Edge を指さない。
- **Edge Id は HEAD と BODY が一つの番号空間を使う。** ドキュメント内で一意で、他の Edge と同じく [NEXT-LOCAL-ID](/ja/grammar/meta/lineage/next-local-id/) から受け取り、再生成するとき同じ内容なら同じ番号を引き継ぐ。HEAD Edge が抜けたバージョンでも、その番号は再利用しない。
- Origin が LOCAL なら、その定義(REFERENCE-NODE、原典 TRIPLE)は BODY に置く。LOCAL はドキュメント全体が範囲だ。
- HEAD Edge は検証クラスの Meta ではないので、[コンテンツハッシュ](/ja/grammar/document/#コンテンツハッシュ)に含まれる。diff では HEAD と一緒にまるごと変わる(`DELTA-REMOVE` には書かない)。
- ドキュメント全体の出典のための Meta は別にない。Meta で書いた原文範囲・入手時刻は、原典が複数あるとき、どの原典についてのものか決められない。SOURCE に付く QUALIFIER は Target でそれを決める。

例: Wikidata ダンプから移した Q42 ドキュメントの HEAD(Edge Id は説明用)。

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         エンティティ版(revision)
#1741 SOURCE     #0     #1740                                         ダンプファイル
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            ファイルハッシュ
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    受信時刻
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      版の保存時刻
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  版の恒久アドレス
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- 版とダンプは別の原典なので、SOURCE を二つ置く。版は内容の原典であり(恒久アドレスで同じ内容を再取得できる)、ダンプはその版を受け取ったファイルだ。ファイルハッシュと受信時刻はダンプファイルに関する引用側の性質なので、ダンプの SOURCE に付く。

## 他の根拠の表現

根拠系列には SOURCE だけを置く。他の根拠は QUALIFIER で書く。

| 根拠 | 書き方 | Property |
|---|---|---|
| 原文内の範囲 | SOURCE に QUALIFIER。範囲一つにつき SOURCE 一つ | ページ P304、節 P958、引用文 P1683。文字範囲は GEUL 用語(未定) |
| 原典資料を受け取った時刻 | SOURCE に QUALIFIER | 参照日 P813 |
| 原文バイトハッシュ(版の固定) | SOURCE に QUALIFIER | チェックサム P4092、値は [SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/) など |
| 作った主体(人、モデル、ルールエンジン) | SOURCE(引用を作った主体)または対象に QUALIFIER | GEUL 用語(未定) |
| 信頼度 | 対象に QUALIFIER | GEUL 用語(未定)、値は Meta [CONFIDENCE](/ja/grammar/meta/verification/confidence/) のように 0~1 |
| 条文ごとの施行期間 | 対象に QUALIFIER | 開始 P580、終了 P582 |
| 移動・分割・統合前の旧レコード | 対象に QUALIFIER、値は旧 Edge Id(LOCAL) | P1365(replaces) |
| 最初に入ったバージョン | 保存しない。バージョン履歴から計算する(git blame) | |

## 例 (非規範)

Q42 P19(出生地) Q350、対象 TRIPLE `#178`。2026-10-19 の Wikidata ダンプの出典四つ。

```
SOURCE     #1347  #178   Q5375741                     ① ブリタニカ: 原典の記述なしで P248 のみ
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② ガーディアン記事 #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: 先に宣言した LOCAL #1158(P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ①は原典の記述がなく P248 が一つだけなので、原典はその項目だ。`#1347` は TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD、TAG `13A0`。

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- URL 一つだけの出典: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`、`SOURCE #1385 #180 #1384`。
- "imported from" で英語版 Wikipedia だけがある出典: `SOURCE #n #t ABSENT`、`QUALIFIER P143 #n Q328`。Origin `0x0000` 1 WORD。

## 未解決の問題

- 文字範囲、作った主体、信頼度を表す GEUL 用語(用語定義ドキュメントと ID)。
- 原典の記述が原典を識別できないとき(言語だけがある出典など)、同じ記述を LOCAL 一つで共有すると、異なる原典を同じものと断言することになる。
- Wikidata 以外の出典(法令、Web 引用)のための原典・引用属性の一覧。
- 出典の出典(連鎖): 原典 LOCAL にさらに SOURCE を付けるか。

## 関連ページ

- [Edge](/ja/grammar/edge/)、[TRIPLE](/ja/grammar/edge/triple/)、[QUALIFIER](/ja/grammar/edge/qualifier/)、[REFERENCE-NODE](/ja/grammar/edge/reference-node/)、[プレースホルダ](/ja/grammar/reference/slot-marker/)
- [ドキュメント](/ja/grammar/document/)(HEAD と BODY)、[Meta — 出典](/ja/grammar/meta/provenance/)
