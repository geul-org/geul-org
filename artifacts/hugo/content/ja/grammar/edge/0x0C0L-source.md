---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE は、レコード 1 つ(対象)またはドキュメント全体を、その出どころである原典につなぐ根拠 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `SOURCE` (規格ドキュメント BIND `SOURCE`) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| 規格ドキュメント | `0x00000000/codecs/0x00000C00/` (DECLARE 対象 `0C00`) |
| セクション | 6 `0110` (Edge 根拠)、セクション内オフセット C = 0 |
| Kind | Edge · 系列: 根拠 |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | レコード 1 つまたはドキュメント全体をその原典につなぐ。Target(BODY の Edge Id、HEAD では `0` = ドキュメント全体)、Origin(Reference、ABSENT または UNKNOWN-VALUE)。原典の性質は原典を Subject とする TRIPLE、引用の性質(参照日、位置、原文ハッシュ)は SOURCE に付く QUALIFIER。ドキュメント全体の SOURCE とその QUALIFIER は HEAD に置く |
| Hugo 側 | `edge/source.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD として宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | レコード | `0050` LOCAL |  |
| 2 | `origin` | #3 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference), `020F` セクション 1 全体(ワイルドカード、Reference), `040F` セクション 2 全体(ワイルドカード、Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT(任意フィールド) |  |

SOURCE は、レコード 1 つ(対象)またはドキュメント全体を、その出どころである原典につなぐ根拠 Edge である。Codec `0x0C0L`。根拠系列(`01`)の唯一の直接コードである。

Wikidata の reference(出典のまとまり)1 つが SOURCE 1 つである。レコード 1 つに出典が複数あれば SOURCE も複数になる。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Target            LOCAL Reference レコード (BODY では根拠を付ける Edge の Edge Id、HEAD では 0 = ドキュメント全体)
Origin            Reference レコード、またはプレースホルダ 0x0000 ABSENT・0x0010 UNKNOWN-VALUE
```

- Origin は原典を指す。原典に合う Reference があればそれ(WIKIDATA-QID、GEUL ドキュメントの DOC-POINTER・EXTERNAL-ISSUER など)、なければこのドキュメントの LOCAL ノードである。
- 出典が原典を記述していなければ(例: Wikidata の "imported from"(P143)・参照日だけがある出典)、Origin は [ABSENT](../slot-marker.md)(記載なし)である。書き手は原典を記さなかっただけで、原典について何も断言していない。出典の残りは QUALIFIER にそのまま残る。
- 書き手が「原典はあるが何かは分からない」と断言するときに限り [UNKNOWN-VALUE](../slot-marker.md) を使う(人が書く記録など)。原典資料から移す変換器は、原典が言っていないことを断言しないので ABSENT を使う。
- ABSENT・UNKNOWN-VALUE の Origin は出現ごとに独立である。2 つの SOURCE の原典を同じものと読まない。

## 二つの層 {#두-층}

出典に関する情報は二つに分かれる。混ぜない。

| 層 | 何か | 書き方 | 例 |
|---|---|---|---|
| 原典 | 原典自体の性質。誰が引用しても同じ | 原典を Subject とする [TRIPLE](0x0AAL-triple.md) (rank normal) | URL(P854)、タイトル(P1476)、著者(P50・P2093)、発行日(P577)、掲載誌(P1433)、発行元(P123)、言語(P407) |
| 引用 | このレコードが原典を引用した行為の性質 | SOURCE の Edge Id を Target とする [QUALIFIER](0x0ABL-qualifier.md) | 参照日(P813)、原典内の位置(ページ P304、節 P958、外部識別子 P227・P1417)、取得元(P143)、推論方法(P887)、原文ハッシュ(P4092) |

- **SOURCE の意味は、その Edge Id を指す QUALIFIER をすべて集めたものである。** 同じ原典を別の日に参照した二つの出典は、原典が同じで QUALIFIER が異なる。
- 原典 TRIPLE は原典についての断言である。どちらの層か決められない性質は引用側(QUALIFIER)に置く。原典について断言しない方が安全である。
- ドキュメント内で同じ原典は LOCAL 1 つで 1 回だけ宣言し、複数の SOURCE が共に指す。
- URL 1 つだけで記述される原典は [REFERENCE-NODE](0x0A0L-reference-node.md)(LOCAL → URI)で定義する。sitelink のドキュメントページと同じ方式である。

## 解釈と有効性 {#해석과-유효성}

- Target、Origin はそれぞれちょうど 1 つの完全なレコードである。Origin を読んだカーソルは Edge の終端と一致しなければならない。
- Target は LOCAL Reference である。BODY の SOURCE は同じドキュメントの BODY の Edge Id を指す。`0`(ドキュメント全体)は HEAD の SOURCE だけが使う([ドキュメント全体の出典](#문서-전체의-출처))。BODY に Target `0` の SOURCE があれば invalid である。他のドキュメントのレコードには、そのドキュメント内で根拠を付ける。
- Origin は Reference である。プレースホルダは `0x0000`(ABSENT)・`0x0010`(UNKNOWN-VALUE)だけを受ける。NO-VALUE(`0x0020`)・Value は受けない。
- geul.org の規格ドキュメント `0x00000000/codecs/0x00000C00`(名前 `source`)は、Target に [CODEC](0x0BEL-codec.md) LOCAL(`0050`)、Origin に CODEC `000F`・`020F`・`040F`(任意の Reference)・`0000`(ABSENT、任意)・`0010`(UNKNOWN-VALUE)を置く。
- 同じ Target の SOURCE 同士の順序に意味はない。出典 1 つの中の項目順にも意味はない(同じ属性の値の順序はドキュメント順として残る)。
- SOURCE は対象の真偽を変えない。対象がどこから来たかを記すだけである。判定結果は [TOULMIN](../toulmin/_index.md) `VERDICT` が担う。

## ドキュメント全体の出典 {#문서-전체의-출처}

ドキュメント全体の原典(元のダンプ、版、原文ファイル)は、**HEAD に Target `0` の SOURCE** として書く。その SOURCE を Target とする QUALIFIER(原文ハッシュ P4092、受信時刻 P813、原文範囲など)も HEAD に置く([ドキュメント](../document.md#head와-body))。

- HEAD に置ける Edge はこの二つだけである。それ以外の Edge は BODY に置く。
- HEAD の QUALIFIER は、それが指す HEAD SOURCE の後に置く。デコーダは先頭から読みながら HEAD と BODY を分ける。
- HEAD SOURCE を Target とする QUALIFIER を BODY に置くと invalid である。BODY の SOURCE・QUALIFIER は HEAD の Edge を指さない。
- **Edge Id は HEAD と BODY が一つの番号空間を使う。** ドキュメント内で一意であり、他の Edge と同様に [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) から受け取り、再生成時に内容が同じなら同じ番号を引き継ぐ。HEAD Edge が抜けた版でも、その番号は再利用しない。
- Origin が LOCAL なら、その定義(REFERENCE-NODE、原典 TRIPLE)は BODY に置く。LOCAL はドキュメント全体が範囲である。
- HEAD Edge は検証クラスの Meta ではないので、[コンテンツハッシュ](../document.md#내용-해시)に入る。diff では HEAD とともにまるごと変わる(`DELTA-REMOVE` には書かない)。
- ドキュメント全体の出典のための Meta は別にない。Meta として書いた原文範囲・取得時刻は、原典が複数あるとき、どの原典についてのものか決められない。SOURCE に付く QUALIFIER は Target によってそれを決める。

例: Wikidata ダンプから移した Q42 ドキュメントの HEAD(Edge Id は説明用)。

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         エンティティの版(revision)
#1741 SOURCE     #0     #1740                                         ダンプファイル
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            ファイルハッシュ
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    受信時刻
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      版の保存時刻
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  版の永続アドレス
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- 版とダンプは別の原典なので SOURCE を二つ置く。版は内容の原典であり(永続アドレスで同じ内容を再取得できる)、ダンプはその版を受け取ったファイルである。ファイルハッシュと受信時刻はダンプファイルに関する引用側の性質なので、ダンプの SOURCE に付く。

## 他の根拠の表現 {#다른-근거의-표현}

根拠系列には SOURCE だけを置く。他の根拠は QUALIFIER で書く。

| 根拠 | 書き方 | Property |
|---|---|---|
| 原文内の範囲 | SOURCE に QUALIFIER。範囲 1 つにつき SOURCE 1 つ | ページ P304、節 P958、引用文 P1683。文字範囲は GEUL 用語(未定) |
| 原典資料を受け取った時刻 | SOURCE に QUALIFIER | 参照日 P813 |
| 原文バイトハッシュ(版の固定) | SOURCE に QUALIFIER | チェックサム P4092、値は [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) など |
| 作成主体(人、モデル、ルールエンジン) | SOURCE(引用を作った主体)または対象に QUALIFIER | GEUL 用語(未定) |
| 信頼度 | 対象に QUALIFIER | GEUL 用語(未定)、値は Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) のように 0〜1 |
| 条文ごとの施行期間 | 対象に QUALIFIER | 開始 P580、終了 P582 |
| 移動・分割・統合前の旧レコード | 対象に QUALIFIER、値は旧 Edge Id(LOCAL) | P1365(replaces) |
| 最初に入った版 | 保存しない。版の履歴から計算する(git blame) | |

## 例 (非規範) {#예시-비규범}

Q42 P19(出生地) Q350、対象 TRIPLE `#178`。2026-10-19 の Wikidata ダンプで、この命題の出典は五つあり、そのうち三つを示す。③ テレグラフ記事(`#1358`〜`#1367`)は②と、⑤ Store norske leksikon(Q746368)は①と同じ形なので省いた。

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

- ①は原典の記述がなく P248 が 1 つなので、原典はその項目である。`#1347` は TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD、TAG `0C07`。

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- URL 1 つだけの出典: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- "imported from" 英語版 Wikipedia だけがある出典: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` は 1 WORD。

## 未解決の問題 {#열린-문제}

- 文字範囲、作成主体、信頼度を表す GEUL 用語(用語定義ドキュメントと ID)。
- 原典の記述が原典を識別できないとき(言語だけがある出典など)、同じ記述を LOCAL 1 つで共有すると、異なる原典を同じものと断言することになる。
- Wikidata 以外の出典(法令、Web 引用)のための原典・引用属性の一覧。
- 出典の出典(連鎖): 原典 LOCAL にさらに SOURCE を付けるか。

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [プレースホルダ](../slot-marker.md)
- [ドキュメント](../document.md)(HEAD と BODY), [Meta — 出典](../meta/_index.md#출처)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000C00/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
