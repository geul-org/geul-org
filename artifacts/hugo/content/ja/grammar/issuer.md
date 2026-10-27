---
title: "Issuer と公表"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Issuer はドキュメントと形式を定義する主体だ。幅(1・2・4・16 WORD)によって発行方式が異なる。このページは Issuer の等級と 1 WORD 割り当て表、ドキュメントの公開方式、署名と検証鍵の公開を定める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL は識別体系を一か所に集めない。各 Issuer が対象と形式を定義し、他のドキュメントは公表された定義を取り込んで使う。定義は社外秘にするか、geul.org(CC0)または非公開の公表(Issuer が定めるライセンス)で公表する。どの定義を信頼して使うかは、ユーザーが決める。

公表アドレス、形式の指定、名前索引、バージョン一覧、信頼層は、[公表アドレスとバージョン一覧](/ja/grammar/publishing/)が定める。

## Issuer が定義するもの

| 対象 | 方法 |
|---|---|
| 対象(エンティティ、概念、用語) | 自分のドキュメントの LOCAL として宣言する |
| Value 形式 | Issuer コードの下の形式番号で定義する |
| Edge 形式 | Issuer コードの下の形式番号で定義する |

- Value・Edge 形式の定義もドキュメントとして公表する。

## 原則

- すべての ID はドキュメントが範囲だ。LOCAL ID(Edge Id、変数を含む)と IMPORT ID は、そのドキュメント内でのみ有効だ。
- Issuer が定義した対象は、その Issuer が公表したドキュメントの LOCAL だ。他のドキュメントは、指示宣言(`EXTERNAL-ISSUER-*`)で直接引用するか、`IMPORT-DOC` で取り込んで `EXTERNAL-POINTER-*` で指す。
- ドキュメントの外から指す必要がある対象には、公表ドキュメントの LOCAL を発行する。そのドキュメントには [DOC-ID](/ja/grammar/meta/declaration/doc-id/) がなければならない。

## Issuer の等級

| 幅 | 値の範囲 | 発行 |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org が標準制定団体と主要機関に割り当て([1 WORD 割り当て表](#1-word-割り当て表)) |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | geul.org に登録。ドメイン所有の証明を経る |
| 4 WORD | `2^32`~`2^64−1` | geul.org に登録。所有の証明はない |
| 16 WORD | `2^64` 以上 | 自己発行。公開鍵から計算する |

- **Issuer ID は整数値だ。** 値が同じなら同じ Issuer だ(`0x0001` と `0x00000001` は同じ値だ)。幅は識別子の一部ではない。
- **正規形は最短幅だ。** 値が収まる最短幅で書き、それより広い幅の表記は拒否する。そのため各幅の割り当ては、すぐ下の幅の範囲が終わった次の値から始まる(2 WORD は `0x00010000` から)。

## 1 WORD 割り当て表

1 WORD Issuer は、geul.org が標準制定団体と主要機関に割り当てる。GEUL が設計した固有形式は `GEUL`、制定団体のないデファクト標準や慣例的な形式は `ADHOC` の下に置く。

| Issuer | 名前 | 団体 | 代表的な形式 |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | GEUL 固有形式、コードブック |
| `0x0001` | ADHOC | geul.org | 制定団体のない慣例的な形式。BFLOAT16、BLAKE3、複素数・分数・区間・四元数、ベクトル・テンソル |
| `0x0002`~`0x000F` | 予約 | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601、ISO 4217(通貨)、ISO 3166(国) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000(単位表記) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | ISO/IEC 情報技術標準 |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509、X.690(ASN.1 エンコード) |
| `0x0014`~`0x001F` | 予約 | 国際標準団体 | |
| `0x0020` | IETF | Internet Engineering Task Force | URI(RFC 3986)、UUID(RFC 9562)、CRC32C、IPv4・IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | メディアタイプ、言語サブタグレジストリ |
| `0x0022` | W3C | World Wide Web Consortium | XML Schema データ型、RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL、HTML |
| `0x0024` | UNICODE | Unicode Consortium | 文字エンコード、正規化、CLDR |
| `0x0025` | ECMA | Ecma International | JSON(ECMA-404) |
| `0x0026`~`0x003F` | 予約 | インターネット・Web 標準団体 | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | IEEE 754 浮動小数点・decimal、MAC アドレス(802) |
| `0x0041` | KHRONOS | Khronos Group | ピクセル形式(RGBA8・BGRA8 UNORM)、glTF |
| `0x0042` | OGC | Open Geospatial Consortium | 座標・バウンディングボックス、GeoJSON 系 |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN・E4M3FNUZ・E5M2・E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Microscaling 形式(E8M0、FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | ドキュメント・セキュリティ標準 |
| `0x0046`~`0x005F` | 予約 | 産業標準団体 | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | SI 単位、TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | うるう秒、UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2(FIPS 180-4)、SHA-3(FIPS 202) |
| `0x0063` | GPS | GPS 政府運用主体 | GPS 時刻 |
| `0x0064`~`0x00FF` | 予約 | 計量・政府機関 | |
| `0x0100` | KATS | 韓国技術標準院 | KS 標準 |
| `0x0101`~`0x01FF` | 予約 | 国家標準機関 | |
| `0x0200`~`0xFFFF` | 予約 | 以後の割り当て | |

- 拡張形式は、その形式を制定した団体の Issuer の下に置く。Issuer の下の形式番号は、各 Issuer が定義する。
- 形式番号の上位ビットは、該当する Kind の系列規則に従わなければならない。そうすればコードブックなしで系列が分かる。
- 標準団体が GEUL 形式番号を直接管理しないなら、geul.org がその団体の標準を代わりに番号として登載する。番号は標準ドキュメントの識別子とともに記録する。
- 割り当ては、団体区分の範囲内で低い番号から行う。範囲は分類の便宜であり、デコーダが解釈する義務はない。

## 16 WORD Issuer

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 署名アルゴリズム ID(2バイト) ‖ 公開鍵)
```

- 結果の 32 バイトを、上位バイトから 16 WORD に書く。
- 登録なしで誰でも作れる。所有はその秘密鍵の署名で証明する。
- 公開鍵とアルゴリズムは、ドキュメント HEAD の [ISSUER-KEY](/ja/grammar/meta/verification/issuer-key/) で宣言する。署名アルゴリズム `0x0001` は Ed25519 で、それ以外の値は予約だ。
- プレフィックス `GEUL-ISSUER-v1` は、同じ鍵を別の用途に使ったときに同じ ID が出ないようにする(用途の分離)。
- 署名アルゴリズムが変わっても(例: Ed25519 → ML-DSA)、ID の幅は 16 WORD のままだ。
- 結果が `2^64` 未満なら(確率は事実上 0)、その鍵では Issuer を作らない。最短幅の規則と重なるからだ。

## ドメイン証明

- 2 WORD Issuer のドメイン所有の証明は、登録時点でのみ確認する。以降のドメイン管理は Issuer の責任だ。
- ドメイン一つは Issuer 一つにだけ対応する。Issuer 一つは複数のドメインを持てる。対応は Issuer 名前索引 `issuers.geul` の BIND で書く([公表アドレスとバージョン一覧](/ja/grammar/publishing/#issuer-名))。
- ドメインが失効したり移転したりしても、対応は最初に証明した Issuer に残る。新しい所有者は、そのドメインを Issuer 名として使えない。
- ドメイン名はアドレス入力と表示用だ。GEUL ドキュメントの中には Issuer ID だけを書く。

## 用語定義ドキュメント

- Issuer が定義した用語(ツール、プログラム、役割、組織内の概念)は、**用語一つにドキュメント一つ**で置く。用語はそのドキュメントの LOCAL で、名前は [BIND](/ja/grammar/edge/bind/) で、指す外部対象(URI など)は [REFERENCE-NODE](/ja/grammar/edge/reference-node/) で結ぶ。
- 他のドキュメントは `EXTERNAL-ISSUER-*`(Issuer、ドキュメント ID、LOCAL ID)で用語を指す。同じ定義をドキュメントごとに繰り返さない。例: [TRANSFORMED-BY](/ja/grammar/meta/lineage/transformed-by/) のツール。
- 用語定義ドキュメントのドキュメント ID の区間は、Issuer が定める。geul.org(`0x0000`)は `0x0001xxxx xxxxxxxx` を使う([Codec 規格ドキュメント](/ja/grammar/codec-spec/#geul-issuer-のドキュメント-id))。
- 各 Issuer のドキュメント ID `0x0000000000000000` は、その Issuer の**用語定義インデックスドキュメント**として予約する: `<Issuer>/0x0000000000000000/`。用語定義ドキュメントを列挙する場所だ。
- インデックスドキュメントは、すべての Issuer に**推奨**する。必須ではない。インデックスがなければ、用語定義ドキュメントは名前索引 `documents.geul` で探す。
- 外部の対象を指す順序: (1) 合う Reference Codec があればそれ(WIKIDATA-QID など)、(2) その対象を定義した GEUL ドキュメントがあればそれ(DOC-POINTER・EXTERNAL-ISSUER)、(3) なければ自分の用語定義ドキュメントに LOCAL として定義して指す。

## ドキュメントの公開方式

| 方式 | 対象 | ライセンス | バージョン管理 | 存続 |
|---|---|---|---|---|
| 社外秘 | すべての Issuer | Issuer 内部 | Issuer | Issuer 次第 |
| geul.org 公表 | 1・2 WORD Issuer | CC0 | geul.org | geul.org が保存 |
| 非公開の公表 | すべての Issuer | Issuer が定める | Issuer | Issuer 次第 |

### geul.org 公表

- 1・2 WORD Issuer は、ドキュメントを geul.org に登録して公表できる。登録ドキュメントは CC0 だ。
  - 1 WORD Issuer は、geul.org の事前審査を経て公表する。
  - 2 WORD Issuer は、登録すればすぐ公表され、問題は事後に措置する。
- 公表できる定義は、概念とコーデックだ。**自然人を指す Reference は geul.org に公表できない。** 社外秘か非公開の公表にする。
  - 例外: [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/) で自然人を指すことは許容する。
- 登録したバージョンは変更も削除もせず、Issuer がなくなってもドキュメントは残る(旧法の保存)。例外は法的削除と職権削除だ([TOMBSTONE](/ja/grammar/edge/publication/))。
- Issuer は、定義に使用中止の勧告(deprecated)だけを表示できる。勧告された定義も引き続き解釈される。
- 同じドキュメントの新しいバージョンは、定義を新設・改訂・削除できる([ドキュメント](/ja/grammar/document/#改訂))。**削除したエンティティ ID と形式番号は、他の対象に再利用しない。** 形式番号の wire レイアウトは改訂しない。

### 非公開の公表

- CC0 でないライセンスで公表したい Issuer は、プライベートネットワーク(独自ドメインなど)でドキュメントを提供する。ライセンスは、ドキュメント HEAD の [LICENSE](/ja/grammar/meta/policy/license/) で宣言する。
- 非公開の公表も geul.org と同じパスを使う([公表アドレスとバージョン一覧](/ja/grammar/publishing/))。
- バージョン管理、可用性、ドメインの維持、ライセンス条件は、Issuer が定める。geul.org は非公開の公表に関与も保証もしない。

### 社外秘

- 社外秘ドキュメントは公表しない。アクセス制御をかけ、[ACCESS](/ja/grammar/meta/policy/access/) で表示する。
- 社外秘の定義を使ったドキュメントを外部に送ると、受け取る側はその Reference・Value・Edge を解釈できず、読み飛ばす。外部とやり取りする定義は公表する。

### ユーザーの選択

- ユーザーは、宣言されたライセンスと Issuer の存続可能性を見て、使うドキュメントを選ぶ。
- 制限が厳しすぎるライセンスや、存続が不安な Issuer の定義は使われない。
- 長く保存されるべき参照には、geul.org 公表ドキュメントを使う。

## 署名

- 署名は公表ドキュメントに必須だ。HEAD に [SIGNATURE](/ja/grammar/meta/verification/signature/) として置く。署名のないドキュメントも有効な GEUL ドキュメントで、社外秘・内部ドキュメントも可能なら署名する。
- 署名の対象は、ドキュメントの**コンテンツハッシュ**だ([ドキュメント](/ja/grammar/document/#コンテンツハッシュ))。BODY だけに署名しない。
  - HEAD には解釈規則がある。`IMPORT-DOC` の対象を変えると、同じ BODY が別の対象を指す。
  - `LICENSE`・`PARENT` に署名しないと、ライセンスと履歴を偽造できる。
- 一つのドキュメントに複数の署名を置ける。すべて同じコンテンツハッシュに署名するので、署名を足してもコンテンツハッシュは変わらない。
- 署名鍵の確認:
  - 1・2・4 WORD Issuer: geul.org に登録した鍵(下の検証鍵の公開)。
  - 16 WORD Issuer: 同じドキュメントの `ISSUER-KEY`。その公開鍵で計算した Issuer ID が、署名者と同じでなければならない。
- 読む側は、署名がなければ信頼度を下げ、署名があるのに検証に失敗すれば、改ざん・なりすましの証拠なのでさらに大きく下げる。
- ドキュメントの署名はそのドキュメントの Issuer が、バージョン一覧の署名はバージョン ID を割り当てた公表元が行う([公表アドレスとバージョン一覧](/ja/grammar/publishing/#署名主体))。

## 検証鍵の公開

- geul.org は、登録 Issuer(1・2・4 WORD)の署名検証鍵を公開する。
- 鍵一覧は、GEUL Issuer(`0x0000`)の公表ドキュメントとして出す。CC0 で、geul.org が署名する。
  - 項目: Issuer、署名アルゴリズム ID、公開鍵、有効開始時点、失効時点と事由。
- 失効した鍵も消さない。過去の署名は、署名時点で有効だった鍵で検証する。
- 鍵の交換は、新しい鍵を旧鍵で署名して登録する。検証する側は、geul.org を信頼しなくても鍵の連続性を確認できる。
- 鍵の変更記録は、追記のみ可能なログに残す(Certificate Transparency、Go sumdb と同じ方式)。履歴を直せば露見する。
- 鍵を失くして旧鍵で署名できなければ、geul.org が身元を再確認して新しい鍵を登録する。2 WORD Issuer は、ドメイン所有の証明を再び経る。この場合は geul.org を信頼しなければならず、事由をログに残す。
- 16 WORD Issuer は該当しない。Issuer ID が公開鍵から計算されるので、ドキュメント内の `ISSUER-KEY` だけで検証する。

## 取り込み

IMPORT はドキュメントだけを取り込む。

```
IMPORT-DOC                      DOC-POINTER(Issuer + ドキュメント ID + バージョン ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + ドキュメント ID + LOCAL ID (IMPORT なしで)
ISSUER-POINTER                  Issuer (Issuer 自身)
DOC-POINTER                     Issuer + ドキュメント ID + バージョン ID (2 WORD、0 なら最新)
```

- どの幅の Issuer とそのドキュメントでも、IMPORT なしで指示宣言で指せる。Issuer 自身は `ISSUER-POINTER`、ドキュメント自身は `DOC-POINTER`、ドキュメントの LOCAL は `EXTERNAL-ISSUER-*` だ。指示宣言は最新バージョンに従い、バージョンを固定するには `IMPORT-DOC`(バージョン ID)と `EXTERNAL-POINTER-*` を使う。
- 本文の Reference は、完全なパス(Issuer + ドキュメント + 対象 ID)の代わりに、IMPORT ID + 対象 ID だけを使う。
- IMPORT ID の幅は、`IMPORT-DOC` では長さで、`EXTERNAL-POINTER-*` では Codec で決まる。そのドキュメント内でのみ有効だ([IMPORT-DOC](/ja/grammar/meta/import/import-doc/))。
- バージョン ID なしで取り込むと、最新バージョンに従う。バージョン ID を書けば、そのバージョンに固定される。公表ドキュメントはバージョン ID を書く。

## ライセンス

- geul.org 公表ドキュメントと GEUL Issuer(`0x0000`)ドキュメントは CC0 だ。
- 非公開の公表ドキュメントのライセンスは、Issuer が定める。GEUL は強制しない。
- GEUL の中核成果物は、CC0 でない Issuer ドキュメントの内容を複製しない。

## 未解決の問題

- 4 WORD・16 WORD Issuer の geul.org 公表を許すか。
- ドメイン所有の証明方式(DNS TXT `_geul.<ドメイン>`、HTTP `.well-known`)と、証明値に署名鍵のフィンガープリントを結びつけるか。
- 鍵紛失の復旧時のドメイン乗っ取り対策。ドメインの再証明だけで新しい鍵を登録すると、乗っ取り者が Issuer を奪える。登録連絡先の確認、猶予期間と旧鍵の異議、ドメイン紛争結果の準用を検討する。
- 用語定義インデックスドキュメント(ドキュメント ID `0`)のレコード形式(用語定義ドキュメントを列挙する Edge)。
- 署名アルゴリズムの既定値(Ed25519 を推奨)。
