---
title: "Issuer と公表"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL は識別体系を一か所に集めない。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL は識別体系を一か所に集めない。各 Issuer が対象と形式を定義し、他のドキュメントは公表された定義を取り込んで使う。定義は社外秘として扱うか、geul.org(CC0)または私設の公表(Issuer が定めるライセンス)で公表する。どの定義を信頼して使うかは、ユーザが決める。

公表アドレス、形式の指定、Issuer 一覧、バージョン一覧、信頼層は[公表アドレスとバージョン一覧](publishing.md)が定める。

## Issuer が定義するもの {#issuer가-정의하는-것}

| 対象 | 方法 |
|---|---|
| 対象(エンティティ、概念、用語) | 自分のドキュメントの LOCAL として宣言する |
| Reference 形式 | Issuer コードの下に 2 WORD の Codec 番号で定義する |
| Value 形式 | Issuer コードの下に 2 WORD の Codec 番号で定義する |
| Edge 形式 | Issuer コードの下に 2 WORD の Codec 番号で定義する |

- Reference・Value・Edge 形式の定義もドキュメントとして公表する。

## 原則 {#원칙}

- Issuer が定義した対象は、その Issuer が公表したドキュメントの LOCAL である。他のドキュメントは指示宣言(`EXTERNAL-ISSUER-*`)で直接引用するか、`IMPORT-DOC` で取り込んで `EXTERNAL-POINTER-*` で指す。[REFERENCE-ISSUER](reference/_index.md#reference-issuer) レコードの意味は、Issuer が発行した Codec ドキュメントが定める。
- ドキュメントの外から指す必要のある対象には、公表ドキュメントの LOCAL を発行する。そのドキュメントには [DOC-ID](meta/0x1C7L-doc-id.md) がなければならない。

## Issuer の等級 {#issuer-등급}

| 幅 | 値の範囲 | 発行 |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | geul.org 登録。ドメイン所有の証明を経る。geul.org が標準制定団体と主要機関に割り当てた番号もこの幅である([2 WORD 割り当て表](#2-word-배정표)) |
| 4 WORD | `2^32`~`2^64−1` | geul.org 登録。所有の証明はない |
| 16 WORD | `2^64` 以上 | 自己発行。公開鍵から計算する |

- **Issuer ID は整数値である。** 値が同じなら同じ Issuer である。幅は識別子の一部ではない。
- **短い Issuer ID に先頭の 0 を付けた長い表記は同じ Issuer である**(2 → 4、2 → 16、4 → 16 WORD)。`0x00000001` と `0x0000000000000001` は同じ Issuer である。そのため 4 WORD Issuer として `0x00000000XXXXXXXX` を、16 WORD Issuer として上位 12 WORD が 0 の値を割り当てない。
- **正規形は最も短い幅である。** レコードには値が収まる最も短い幅で書き、より広い幅の表記は拒否する。そのため各幅の割り当ては、すぐ下の幅の範囲が終わった次の値から始まる。2 WORD が最も短い幅である。公表アドレスに使うときは、発行幅の桁数(2 WORD は 8 桁、4 WORD は 16 桁、16 WORD は 64 桁)と 16 進大文字で書き(小文字で書かれたアドレスも大文字に直して探す)、読むときは広げた表記も同じ Issuer として受け取る([公表アドレスとバージョン一覧](publishing.md#id-표기))。

## 2 WORD 割り当て表 {#2-word-배정표}

geul.org は標準制定団体と主要機関に、2 WORD Issuer 番号を先頭から順に割り当てる。制定団体のない事実上の標準や慣例形式は `ADHOC`(`adhoc.geul.org`)の下に置く。GEUL が設計した固有の形式は直接コードである。標準制定団体の Issuer は geul.org のサブドメイン Issuer である。サブドメイン名は小文字の機関名である(`<機関名>.geul.org`、例: `iso.geul.org`、`iec.geul.org`)。ドメインは下の表に記す。

| Issuer | 名前 | ドメイン | 団体 | 代表的な形式 |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | 直接コードの規格ドキュメント(コードブック) |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | Wikidata の項目・プロパティのドキュメント |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | 制定団体のない慣例形式。BFLOAT16、BLAKE3、複素数・分数・区間・四元数、ベクトル・テンソル |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601、ISO 4217(通貨)、ISO 3166(国) |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000(単位表記) |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | ISO/IEC 情報技術標準 |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509、X.690(ASN.1 エンコーディング) |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI(RFC 3986)、UUID(RFC 9562)、CRC32C、IPv4・IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | メディアタイプ、言語サブタグのレジストリ |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | XML Schema データ型、RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL、HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | 文字エンコーディング、正規化、CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON(ECMA-404) |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | IEEE 754 浮動小数点・decimal、MAC アドレス(802) |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | ピクセル形式(RGBA8・BGRA8 UNORM)、glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | 座標・境界ボックス、GeoJSON 系 |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN・E4M3FNUZ・E5M2・E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Microscaling 形式(E8M0、FP4 E2M1) |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | ドキュメント・セキュリティ標準 |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | SI 単位、TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | うるう秒、UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2(FIPS 180-4)、SHA-3(FIPS 202) |
| `0x00000016` | GPS | `gps.geul.org` | GPS 政府運用主体 | GPS 時刻 |
| `0x00000017` | KATS | `kats.geul.org` | 韓国国家技術標準院(국가기술표준원) | KS 標準 |

- 拡張形式は、その形式を制定した団体の Issuer の下に置く。Issuer の下の Codec 番号は各 Issuer が定義する。
- Codec 番号は Issuer が定める。GEUL は意味を定めない。Codec 番号は Kind に関係なく、その Issuer の中で重複しない([公表アドレスとバージョン一覧](publishing.md#id-표기))。
- 標準団体が GEUL の Codec 番号を直接管理しない場合は、geul.org がその団体の標準を代わりに番号として登載する。番号は標準ドキュメントの識別子とともに記録する。
- 新しい標準制定団体は、次の空き番号を受け取る。
- **ドメインは変わりうる。** Issuer とドメインのバインドは後で変わりうる。Issuer ID は変わらない。機関が直接管理するようになれば、その機関の公式ドメインに置き換える。
- **geul.org のサブドメインは公式の発行元ではない。** 標準機関の名前を使った geul.org のサブドメインは、その機関の公式の発行元ではない。たとえば `iso.geul.org` は ISO の公式の発行元ではない。

## 16 WORD Issuer {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 署名アルゴリズム ID(2バイト) ‖ 公開鍵)
```

- 結果の 32 バイトを、上位バイトから 16 WORD に書く。
- 登録なしに誰でも作れる。所有はその秘密鍵の署名で証明する。
- 公開鍵とアルゴリズムは、ドキュメント HEAD の [ISSUER-KEY](meta/0x1E5L-issuer-key.md) で宣言する。署名アルゴリズム `0x0001` は Ed25519 であり、それ以外の値は Reserved である。
- 接頭辞 `GEUL-ISSUER-v1` は、同じ鍵を別の用途に使ったときに同じ ID が出ないようにする(用途の分離)。
- 署名アルゴリズムが変わっても(例: Ed25519 → ML-DSA)、ID の幅は 16 WORD のまま同じである。
- 結果が `2^64` 未満なら(確率は事実上 0)、その鍵では Issuer を作らない。最も短い幅の規則と重なるからである。

## ドメインの証明 {#도메인-증명}

- 2 WORD Issuer のドメイン所有の証明は、登録時にのみ確認する。以後のドメイン管理は Issuer の責任である。
- ドメイン 1 つは Issuer 1 つにのみ対応する。Issuer 1 つは複数のドメインを持てる。対応は Issuer 一覧 `issuers/` の BIND で記す([公表アドレスとバージョン一覧](publishing.md#issuer-목록))。
- ドメインが失効したり移転したりしても、対応は最初に証明した Issuer に残る。新しい所有者はそのドメインを Issuer 名として使えない。
- ドメイン名はリゾルバ・CLI の入力と表示用である。公表 URL アドレスではない([公表アドレスとバージョン一覧](publishing.md#도메인-이름))。GEUL ドキュメントの中には Issuer ID だけを書く。

## 用語定義ドキュメント {#용어-정의-문서}

- Issuer が定義した用語(ツール、プログラム、役割、組織内の概念)は、**用語 1 つにドキュメント 1 つ**で置く。用語はそのドキュメントの LOCAL であり、名前は [BIND](edge/0x0A3L-bind.md) で、指す外部対象(URI など)は [REFERENCE-NODE](edge/0x0A0L-reference-node.md) でつなぐ。
- 他のドキュメントは `EXTERNAL-ISSUER-*`(Issuer、ドキュメント ID、LOCAL ID)で用語を指す。同じ定義をドキュメントごとに繰り返さない。例: [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) のツール。
- 用語定義ドキュメントのドキュメント ID の区間は Issuer が定める。geul.org(`0x00000000`)は `0x0001xxxx xxxxxxxx` を使う。
- すべての Issuer はドキュメント ID `0x0000000000000000` と `0xFFFFFFFFFFFFFFFF` を予約する。現在の用途は次の 2 つである。
- ドキュメント ID `0x0000000000000000` は、その Issuer の**用語定義索引ドキュメント**の位置である: `<Issuer>/docs/0x0000000000000000/`。用語定義ドキュメントを列挙する位置である。
- ドキュメント ID `0xFFFFFFFFFFFFFFFF` は、Issuer geul.org(`0x00000000`)の Issuer 一覧 `issuers/` に使う。他の Issuer はこの ID を使わない。この ID は、どの Issuer でも `<Issuer>/docs/<ドキュメント ID>/` のアドレスでは受け付けない(404)([公表アドレスとバージョン一覧](publishing.md#목록-문서))。
- 索引ドキュメントはすべての Issuer に**推奨**する。必須ではない。
- 外部対象を指す順序: (1) 合う Reference Codec があればそれ(WIKIDATA-QID など)、(2) その対象を定義した GEUL ドキュメントがあればそれ(DOC-POINTER・EXTERNAL-ISSUER)、(3) なければ自分の用語定義ドキュメントに LOCAL として定義して指す。

## ドキュメントの公開方式 {#문서-공개-방식}

| 方式 | 対象 | ライセンス | バージョン管理 | 存続 |
|---|---|---|---|---|
| 社外秘 | すべての Issuer | Issuer 内部 | Issuer | Issuer 次第 |
| geul.org 公表 | 2 WORD Issuer | CC0 | geul.org | geul.org が保存 |
| 私設の公表 | すべての Issuer | Issuer が定める | Issuer | Issuer 次第 |

### geul.org 公表 {#geulorg-공표}

- 2 WORD Issuer は、ドキュメントを geul.org に登録して公表できる。登録ドキュメントは CC0 である。登録すればすぐ公表され、問題は事後に対処する。
- 公表できる定義は概念と Codec である。**自然人を指す Reference は geul.org に公表できない。** 社外秘か私設の公表にする。
  - 例外: [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) で自然人を指すことは許可する。
- 登録したバージョンは変更も削除もせず、Issuer が消滅してもドキュメントは残る(旧法の保存)。例外は法的削除と職権削除である([TOMBSTONE](edge/0x0BAL-tombstone.md))。
- Issuer は定義に使用中止の勧告(deprecated)だけを表示できる。勧告された定義も引き続き解釈される。
- 同じドキュメントの新しいバージョンは、定義を新設・改訂・削除できる([ドキュメント](document.md#개정))。**削除したエンティティ ID と Codec 番号は他の対象に再利用しない。** Codec 番号の wire レイアウトは改訂しない。

### 私設の公表 {#사설-공표}

- CC0 でないライセンスで公表したい Issuer は、私設ネットワーク(自前のドメインなど)でドキュメントを提供する。ライセンスはドキュメント HEAD の [LICENSE](meta/0x1DEL-license.md) で宣言する。
- 私設の公表も geul.org と同じパスを使う([公表アドレスとバージョン一覧](publishing.md))。
- バージョン管理、可用性、ドメインの維持、ライセンス条件は Issuer が定める。geul.org は私設の公表に関与も保証もしない。

### 社外秘 {#대외비}

- 社外秘のドキュメントは公表しない。アクセス制御をかけ、[ACCESS](meta/0x1DFL-access.md) で表示する。
- 社外秘の定義を使ったドキュメントを外部に送ると、受け取る側はその Reference・Value・Edge を解釈できず読み飛ばす。外部とやり取りする定義は公表する。

### ユーザの選択 {#사용자의-선택}

- ユーザは、宣言されたライセンスと Issuer の存続可能性を見て、使うドキュメントを選ぶ。
- 過度に制限的なライセンスや、存続が不安な Issuer の定義は使われない。
- 長く保存されるべき参照には、geul.org の公表ドキュメントを使う。

## 署名 {#서명}

- 署名は公表ドキュメントに必須である。HEAD に [SIGNATURE](meta/0x1E6L-signature.md) として置く。署名のないドキュメントも有効な GEUL ドキュメントであり、社外秘・内部のドキュメントも可能なら署名する。
- 署名の対象はドキュメントの**コンテンツハッシュ**である([ドキュメント](document.md#내용-해시))。BODY だけに署名しない。
  - HEAD には解釈規則がある。`IMPORT-DOC` の対象を変えると、同じ BODY が別の対象を指す。
  - `LICENSE`・`PARENT` に署名しないと、ライセンスと履歴を偽造できる。
- 1 つのドキュメントに複数の署名を置ける。すべて同じコンテンツハッシュに署名するため、署名を加えてもコンテンツハッシュは変わらない。
- 署名鍵の確認:
  - 2・4 WORD Issuer: geul.org に登録した鍵(下の検証鍵の公開)。
  - 16 WORD Issuer: 同じドキュメントの `ISSUER-KEY`。その公開鍵で計算した Issuer ID が署名者と同じでなければならない。
- 読む側は、署名がなければ信頼度を下げ、署名があるのに検証に失敗すれば改ざん・なりすましの証拠であるため、より大きく下げる。
- ドキュメントの署名はそのドキュメントの Issuer が、バージョン一覧の署名はバージョン ID を割り当てた公表元が行う([公表アドレスとバージョン一覧](publishing.md#서명-주체))。

## 検証鍵の公開 {#검증키-공개}

- geul.org は、登録 Issuer(2・4 WORD)の署名検証鍵を公開する。
- 鍵一覧は GEUL Issuer(`0x00000000`)の公表ドキュメントとして出す。CC0 であり、geul.org が署名する。
  - 項目: Issuer、署名アルゴリズム ID、公開鍵、有効開始時点、失効時点と理由。
- 失効した鍵も消さない。過去の署名は、署名時点で有効だった鍵で検証する。
- 鍵の交換は、新しい鍵を旧い鍵で署名して登録する。検証する側は geul.org を信頼しなくても、鍵の連続性を確認できる。
- 鍵の変更記録は、追記のみ可能なログとして残す(Certificate Transparency、Go sumdb と同じ方式)。履歴を直せば露見する。
- 鍵を紛失して旧い鍵で署名できない場合は、geul.org が身元を再確認して新しい鍵を登録する。2 WORD Issuer はドメイン所有の証明をやり直す。この場合は geul.org を信頼する必要があり、理由をログに残す。
- 16 WORD Issuer は該当しない。Issuer ID が公開鍵から計算されるため、ドキュメント内の `ISSUER-KEY` だけで検証する。

## 取り込み {#가져오기}

IMPORT はドキュメントだけを取り込む。

```
IMPORT-DOC                      DOC-POINTER(Issuer + ドキュメント ID + バージョン ID) + IMPORT ID
                                コーデックのドキュメントは CODEC-POINTER(Issuer + Codec ID + バージョン ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4WORD      IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + ドキュメント ID + LOCAL ID (IMPORT なしで)
ISSUER-POINTER                  Issuer (Issuer 自身)
DOC-POINTER                     Issuer + ドキュメント ID + バージョン ID (2 WORD, 0 なら最新)
CODEC-POINTER                   Issuer + Codec ID + バージョン ID (2 WORD, 0 なら最新)
```

- どの幅の Issuer とそのドキュメントでも、IMPORT なしに指示宣言で指せる。Issuer 自身は `ISSUER-POINTER`、ドキュメント自身は `DOC-POINTER`、ドキュメントの LOCAL は `EXTERNAL-ISSUER-*` である。指示宣言は最新バージョンに従い、バージョンを固定するには `IMPORT-DOC`(バージョン ID)と `EXTERNAL-POINTER-*` を使う。
- 外部ドキュメントの対象を指す本文の Reference は、全体のパス(Issuer + ドキュメント + 対象 ID)の代わりに、IMPORT ID + 対象 ID だけを使う。[REFERENCE-ISSUER](reference/_index.md#reference-issuer) は Issuer と Codec 番号を書く。
- IMPORT ID の幅は、`IMPORT-DOC` では長さで、`EXTERNAL-POINTER-*` では Codec で定まる([IMPORT-DOC](meta/0x1E4L-import-doc.md))。
- バージョン ID なしで取り込めば最新バージョンに従う。バージョン ID を書けばそのバージョンに固定される。公表ドキュメントはバージョン ID を書く。

## ライセンス {#라이선스}

- geul.org の公表ドキュメントと GEUL Issuer(`0x00000000`)のドキュメントは CC0 である。
- 私設の公表ドキュメントのライセンスは Issuer が定める。GEUL は強制しない。
- **Issuer 形式のライセンス。** geul.org が提供する直接コードと公表物だけが CC0 である。Issuer 形式のライセンスは、その Issuer が定める。
- **Issuer の表示。** GEUL は Resolve を Issuer の表示に依存する。他の Issuer の Codec を使うドキュメントには、その Issuer が常に表示される。
- GEUL のコア成果物は、CC0 でない Issuer ドキュメントの内容を複製しない。

## 未解決の問題 {#열린-문제}

- ドメイン所有の証明方式(DNS TXT `_geul.<ドメイン>`、HTTP `.well-known`)と、証明値に署名鍵のフィンガープリントを結びつけるか。
- 鍵紛失の復旧時のドメイン乗っ取りへの対応。ドメインの再証明だけで新しい鍵を登録すると、乗っ取り犯が Issuer を奪える。登録連絡先の確認、猶予期間と旧鍵による異議、ドメイン紛争結果の準用を検討する。
- 用語定義索引ドキュメント(ドキュメント ID `0`)のレコード形式(用語定義ドキュメントを列挙する Edge)。
- 署名アルゴリズムの既定値(Ed25519 を推奨)。
