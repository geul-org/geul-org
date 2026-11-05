---
title: "公表アドレスとバージョン一覧"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL は文字列の URL ではなく ID(Issuer、ドキュメント ID、バージョン ID)でドキュメントを指す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL は文字列の URL ではなく ID(Issuer、ドキュメント ID、バージョン ID)でドキュメントを指す。アドレスは ID から定まる。このページは、エンコーダ・デコーダ・リゾルバが噛み合って動作するために必要な公表規則を定める。Issuer の等級と公開方式は [Issuer と公表](issuer.md)が定める。

## ID の表記 {#id-표기}

アドレスに使う ID は hex で書く。

- 接頭辞は小文字の `0x` である。16 進は A-F の大文字で書く。リゾルバは、小文字で書かれたアドレスも大文字に直して探す。
- 桁数は幅 × 4 に固定する。先頭の 0 を省略せず、桁数がそのまま幅である。
- アドレスを書くとき、Issuer は発行幅の桁数で書く: 2 WORD は 8 桁、4 WORD は 16 桁、16 WORD は 64 桁。
- 読むとき、Issuer は 8 桁、16 桁、64 桁のいずれも受け取る。短い Issuer ID に先頭の 0 を付けた長い表記は同じ Issuer として探す(`0x00000001` と `0x0000000000000001` は同じ Issuer である、[Issuer と公表](issuer.md#issuer-등급))。

| 対象 | 幅 | 桁数 | 例 |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 桁 |
| Codec ID | 2 WORD | 8 | `0x00000AA0` |
| ドキュメント ID | 4 WORD | 16 | `0x0000000000000000` |
| バージョン ID | 2 WORD | 8 | `0x00000003` |
| コンテンツハッシュ | 16 WORD | 64 | `0x` + 64 桁 |

- GEUL 直接コードの Codec ID は、その TAG WORD(L=0)を 32 ビットで表した値である(TRIPLE `0x0AAL` → `0x00000AA0`)。Kind が TAG に含まれているため重複しない。
- 他の Issuer の ISSUER 形式 Codec は、その Issuer の `codecs/` の下に、レコードの Codec 番号で置く。例: IETF CRC32C は `0x00000007/codecs/0x0000C000/`。
- Issuer Codec の Codec ID は、レコードの Codec 番号(2 WORD)である。Issuer は Kind(Reference、Value、Edge)に関係なく、自分の `<Issuer>/codecs/` の中で Codec 番号が重複しないように割り当てる。アドレスは Kind で分けない(`references/`、`values/`、`edges/` のようなフォルダはない)。
- リゾルバは、レコードの Kind と、その Codec ドキュメントの [DECLARE](edge/0x0BBL-declare.md) 対象の Kind が異なれば、エラーとみなす。
- 公表は、同じ Codec ID に別の Codec を載せることを拒否する。
- バージョン ID の規則(1 から、`0` は最新、公表元が割り当て、使い切ったら新しいドキュメント ID)は[ドキュメント](document.md#버전)が定める。

## 公表アドレス {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              Issuer 一覧 最新
/.well-known/geul/issuers/<バージョン ID>.geul                      Issuer 一覧 バージョン指定
/.well-known/geul/issuers/versions.geul                            Issuer 一覧 バージョン一覧
/.well-known/geul/<Issuer>/codecs/<Codec ID>/latest.geul           Codec 最新
/.well-known/geul/<Issuer>/codecs/<Codec ID>/<バージョン ID>.geul   Codec バージョン指定
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul         Codec バージョン一覧
/.well-known/geul/<Issuer>/docs/<ドキュメント ID>/latest.geul      ドキュメント 最新
/.well-known/geul/<Issuer>/docs/<ドキュメント ID>/<バージョン ID>.geul   ドキュメント バージョン指定
/.well-known/geul/<Issuer>/docs/<ドキュメント ID>/versions.geul    ドキュメント バージョン一覧
/.well-known/geul/<Issuer>/hashes/<コンテンツハッシュ>.geul         コンテンツハッシュで照会
```

例: `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- パスは RFC 8615 の `.well-known` に従う。geul.org と私設の公表が同じパスを使い、ドメインだけが異なる。登録する接尾辞は `geul` の 1 つである。
- Issuer 一覧は `issuers/` である。Codec、一般のドキュメント、ハッシュは、Issuer フォルダの下の `codecs/<Codec ID>/`、`docs/<ドキュメント ID>/`、`hashes/` に分かれる。Issuer 一覧もバージョン 1 から始まり、`versions.geul` を置く([一覧ドキュメント](#목록-문서))。
- `latest.geul` は予約語であり、別名である。保存しない。同じ位置の `versions.geul` から最も新しいバージョンを探し、そのバージョンのバイト列をそのまま返す。リダイレクトしない。Issuer 一覧、Codec、ドキュメントのすべての `latest.geul` が同じである。
- 1 つのバージョンの正本アドレスは `/<Issuer>/docs/<ドキュメント ID>/<バージョン ID>.geul` である。Codec は `/<Issuer>/codecs/<Codec ID>/<バージョン ID>.geul` である。同じ内容を返す他のアドレスは、`Link: rel=canonical` で正本アドレスを指す。
- バージョン指定アドレスとコンテンツハッシュアドレスは不変である。不変アドレスは永久キャッシュと CDN に置ける。受け取った側は、バージョン一覧(またはロックレコード)のコンテンツハッシュで検証する。
- コンテンツハッシュで探すには Issuer を知っている必要がある。ハッシュだけで探すグローバルな照会はない。
- Codec ドキュメントにはドキュメント ID がない。[CODEC-POINTER](reference/0x042L-codec-pointer.md)(Issuer、Codec ID、バージョン ID)で自分とバージョンを指す。
- ID は常に `0x` で始まる。そのため予約名(`issuers`、`codecs`、`docs`、`hashes`、`latest.geul`、`versions.geul`)や、人が付けた名前は、`add`、`cafe` のように hex だけの単語であっても ID と重ならない。
- 位置(どのサーバから受け取るか)はドキュメントの内容に入れない。入れるとアドレスが変わったときにコンテンツハッシュが変わる。位置はドキュメントを受け取る側の設定が定める。

### 公表形態と照会 {#공표-형태와-조회}

- アドレスは論理アドレスである。公表元は個別ファイルまたは pack として出せる。pack の場合、アドレス URL で直接は受け取れず、GEUL リゾルバで読む。
- 個別ファイル、pack、zstd pack のどの形態で保存されていても、同じアドレスで探せる。上の 10 種類の形式の外のアドレスと、存在しないアドレスは 404(なし)である。

コマンドラインツール `geul`([gogeul](https://github.com/geul-org/gogeul)):

```
geul get <アドレス>     純粋な GEUL ドキュメントのバイナリを標準出力に出す
geul show <アドレス>    ドキュメントをテキストで表示する
```

- `geul get` は `file://`、`https://` のアドレスを受け取る。10 種類の形式の外のアドレスと存在しないアドレスは、404(なし)で終わる。

Go ライブラリ gogeul の `pkg/resolve` は、アドレスごとに照会関数を置く。すべて純粋な GEUL バイナリ(`[]byte`)を返す。バージョン ID は 1 から始まるため、`Latest`(0)が最新である。存在しないアドレスは、なしエラー(`ErrNotFound`)である。

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // 10種類以外の形式は 404(なし)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → 標準出力
```

### 形式の指定 {#형식-지정}

- 公表アドレスは `.geul` で終わり、バイナリ(`application/vnd.geul`)である。
- ドキュメントはバイナリが正本である。コンテンツハッシュと署名はバイナリでのみ計算する。

### 一覧ドキュメント {#목록-문서}

一覧ドキュメントは Issuer 一覧 `issuers/` の 1 つである。Issuer とドメインを結ぶ([Issuer 一覧](#issuer-목록))。バージョン 1 から始まり、`versions.geul` を置く。一覧のドキュメント ID は、予約ドキュメント ID `0xFFFFFFFFFFFFFFFF`(Issuer geul.org `0x00000000`)である。すべての Issuer はドキュメント ID `0x0000000000000000` と `0xFFFFFFFFFFFFFFFF` を予約する([Issuer と公表](issuer.md#용어-정의-문서))。

- `latest.geul` は保存しない別名である。`versions.geul` から最も新しいバージョンを探し、そのバイト列を返す。
- `issuers/versions.geul` の PUBLICATION・DEPRECATION・TOMBSTONE は、DOC-POINTER(`0x00000000`、`0xFFFFFFFFFFFFFFFF`、バージョン ID)で一覧のバージョンを指す。そのため `hashes/` で受け取っても何の一覧かが分かる([PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록))。
- ドキュメント ID `0xFFFFFFFFFFFFFFFF` は、どの Issuer でも `<Issuer>/docs/<ドキュメント ID>/` のアドレスでは受け付けない(404)。もう一方の予約ドキュメント ID `0x0000000000000000` は、その Issuer の用語定義索引ドキュメントとして `docs/` の下に置く([Issuer と公表](issuer.md#용어-정의-문서))。
- 一覧ドキュメントには `DOC-ID` を置かない。何の一覧かは、レコードの DOC-POINTER が語る([DOC-ID](meta/0x1C7L-doc-id.md))。
- ドキュメントと Codec は、一覧なしに、レコードから計算した ID で直接探す([ドキュメント名](#문서-이름))。

### ドメイン名 {#도메인-이름}

ドメイン名は公表 URL アドレスではない。`<Issuer>` の位置にドメインを書いたり、ID の位置に名前を書いたりしたアドレスは、上の 10 種類の形式の外であるため 404(なし)である。名前から ID アドレスへ送るリダイレクトもない。

- ドメイン名は、リゾルバと CLI の入力である。リゾルバは Issuer 一覧 `issuers/` の BIND でドメインを Issuer ID に変換する。変換した ID はロックレコードに残す。ドキュメント名のアドレスはない([ドキュメント名](#문서-이름))。
- 正本アドレス、キャッシュキー、署名の対象は ID アドレスである。
- ドメインは小文字で書き、国際化ドメインは IDNA(punycode)形式で書く。末尾の `.` は付けない。
- 登録簿のない 16 WORD Issuer と、geul.org に到達できないエアギャップ環境は、ドメイン名を使えない。ID を使う。

### Issuer 一覧 {#issuer-목록}

Issuer 一覧は `/.well-known/geul/issuers/` の下のドキュメントである(最新は `issuers/latest.geul`)。Issuer とその名前(ドメイン)を結ぶ。

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   名前 = "geul.org"
  …
```

- Subject は [ISSUER-POINTER](reference/0x040L-issuer-pointer.md)(Issuer 自身)であり、名前は [BIND](edge/0x0A3L-bind.md) で結ぶ。
- 名前は、ドメイン所有の証明を経たドメインである。小文字であり、国際化ドメインは IDNA(punycode)で書く。名前 1 つは Issuer 1 つにのみ結ばれる。
- 人が読む Issuer の表示名(言語別)は、同じ Subject に叙述 [LABEL](edge/0x0A4L-label.md) として付ける。
- geul.org(GEUL Issuer)が署名し、変わるときは追記し、書き換えない(バージョン一覧と同じチェーン規則)。

### ドキュメント名 {#문서-이름}

**ドキュメント名のアドレスはない。** ドキュメントと Codec は ID で探す。

- ドキュメント名・Codec 名を ID に変換する索引は置かない。バージョン一覧にもドキュメント名の [BIND](edge/0x0A3L-bind.md) を置かない([PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서))。
- 人が見て回る索引は、ツール(ビューア)が pack のインベントリから作る。
- 正本アドレス、キャッシュキー、署名の対象は ID アドレスである。IMPORT とドキュメント内の引用は ID だけで行う。
- 人が読むタイトル(言語別)は、叙述 [LABEL](edge/0x0A4L-label.md) として付ける。

### 削除されたドキュメント {#삭제된-문서}

- 法的削除・職権削除で廃棄されたバージョン(TOMBSTONE)のアドレスも、他の存在しないアドレスと同様に 404(なし)である。
- 使用中止を勧告したバージョン(DEPRECATION)は 404 ではない。そのバージョンのアドレスで引き続き返す。
- 削除は、バージョン一覧に [TOMBSTONE](edge/0x0BAL-tombstone.md) レコード(そのバージョンの DOC-POINTER、理由の区分)として残る。

## 層 {#층}

GEUL は出典・メタ・一覧まで GEUL ドキュメントで表現する。それを読むのに必要な最小限はデコーダに内蔵して循環を断つ。各層は下の層にのみ依存する。

| 層 | 内容 | 依存するもの |
|---|---|---|
| 層 0 | デコーダ内蔵の規則: フレーミング、コンテンツハッシュ、署名検証、バージョン一覧レコードの Codec(`PUBLICATION`・`DEPRECATION`・`TOMBSTONE`)、Codec 規格の語彙(`DECLARE`・`FIELD`・`ENUM`・`CODEC`)、[プレースホルダ](slot-marker.md)(`0x0000`、`0x0010`、`0x0020`)、ドキュメントの外から受け取る信頼鍵 | なし。照会しない |
| 層 1 | バージョン一覧ドキュメント | 層 0 |
| 層 2 | 一般のドキュメント、コードブック、Codec 規格ドキュメント、Issuer 検証鍵ドキュメント | 層 1 で探し、層 0 で検証する |

- どの層も、自分の層や上の層に依存しない。
- GEUL で表現することと、GEUL で解釈しなければ読めないことを区別する。層 0 は GEUL で表現できても、解釈に照会を必要としない。
- 判定の意味のように、TOULMIN ドキュメントに置き換えられない固定のコアもこの位置に置く([TOULMIN](toulmin/_index.md#메타-인지와-자기-개정))。

## バージョン一覧 {#버전-목록}

公表元は、ドキュメントごとにバージョン一覧ドキュメントを 1 つ書き継ぐ(`/<Issuer>/docs/<ドキュメント ID>/versions.geul`、Codec は `/<Issuer>/codecs/<Codec ID>/versions.geul`、Issuer 一覧は `issuers/versions.geul`)。レコード形式とドキュメント構造は [PUBLICATION](edge/0x0B8L-publication.md) が定める。

```
DOC-*
  SPEC-VERSION
  PARENT          直前のバージョン一覧のコンテンツハッシュ
  RECORDED-AT     この一覧を出した時刻
  NEXT-LOCAL-ID   次に割り当てる LOCAL ID
  SIGNATURE       公表元の署名
BODY
  PUBLICATION     #1  ドキュメント@1  コンテンツハッシュ
  PUBLICATION     #2  ドキュメント@2  コンテンツハッシュ
  DEPRECATION     #3  ドキュメント@1
  …
END
```

| Edge | 意味 |
|---|---|
| PUBLICATION | ドキュメントの 1 つのバージョンとそのコンテンツハッシュを公表する |
| DEPRECATION | 公表したバージョンに使用中止の勧告を表示する。引き続き解釈される |
| TOMBSTONE | 公表したバージョンを削除する(法的・職権削除)。理由の区分を書く |

- レコードは追記のみである。書き換えたり、消したり、順序を変えたりしない。deprecate・削除もレコードを追記する。新しい一覧は、直前の一覧の BODY をそのまま先頭に置いてレコードを追記し、一覧同士は `PARENT` のハッシュチェーンでつながる。
- 公表記録を書き換えないという意味であり、ドキュメント内容の改訂([ドキュメント](document.md#개정))とは異なる。バージョンの現在の状態は、レコードを順に適用して計算する。
- バージョン ID は 1 から欠番なく昇順である。同じ内容を再び公表しない。
- 最新バージョンは、廃止勧告も削除もされていない最も高いバージョンである。
- レコードには時刻を入れない。そのレコードが最初に載った一覧の `RECORDED-AT` が公表時刻である。
- バージョン一覧には `DOC-ID` を置かない。レコードの DOC-POINTER(ドキュメント ID、Issuer 一覧は予約ドキュメント ID)が、何の一覧かを語る。
- バージョン一覧は IMPORT を置かず、層 0 の Codec だけを使う。BODY には PUBLICATION・DEPRECATION・TOMBSTONE だけを置く。
- 過去のバージョン一覧は、コンテンツハッシュ(`<Issuer>/hashes/<コンテンツハッシュ>.geul`)でのみ指し、履歴は `PARENT` チェーンでつなぐ。
- 可変のアドレスは `latest.geul` と `versions.geul` である。可変ポインタはドキュメントにできないため、受け取った一覧の署名・`RECORDED-AT`・`PARENT` で検証する。

### 署名の主体 {#서명-주체}

| 署名 | 主体 | 対象 |
|---|---|---|
| ドキュメント署名 | そのドキュメントの Issuer | ドキュメントのコンテンツハッシュ ([Issuer と公表](issuer.md#서명)) |
| 一覧署名 | バージョン ID を割り当てた公表元 | バージョン一覧のコンテンツハッシュ |

- geul.org の公表は geul.org(GEUL Issuer)が、私設の公表はその Issuer が、バージョン ID を割り当てて一覧に署名する。
- 著者は内容に、公表元は番号と順序に責任を負う。

### 検証 {#검증}

- 署名はコンテンツハッシュから除かれるため、消してもハッシュは変わらない。そのため「署名があれば確認する」ではなく「定められた鍵の署名がなければならない」で検証する。要求する鍵は、リゾルバの信頼設定とロックレコードが定める。
- リゾルバは、最後に見た一覧のコンテンツハッシュをロックレコードに残す。新しく受け取った一覧の `PARENT` チェーンにそのハッシュがなければ拒否する(巻き戻し・分岐の防止)。
- ミラーとエアギャップ環境は、バージョン一覧のチェーンを一緒にコピーする。公開鍵さえあればオフラインで検証できる。
- 受け取ったドキュメントは、どの出所から来ても、コンテンツハッシュで検証する。出所を信頼する必要はない。

## 依存関係の解決 {#의존성-해석}

- ドキュメントは HEAD の [IMPORT-DOC](meta/0x1E4L-import-doc.md) で、依存するドキュメントを書く。
- 新しいバージョンは、以前のバージョンとの互換を約束しない。そのため、グラフ全体で 1 つのドキュメントのバージョンを 1 つに統合しない(最小バージョン選択を使わない)。
- 各 `IMPORT-DOC` は、自分が固定した版にバインドされる。同じドキュメントの複数の版が 1 つのグラフに同居できる(旧法を引用した判決と現行法を引用した判決)。参照は(ドキュメント、バージョン、LOCAL ID)で解決する。
- 最新(バージョン `0`)の取り込みは、解釈時点の最新の版にバインドされる。時点を定めて解釈すれば、その時点で施行中の版にバインドされる([ドキュメント](document.md#개정))。
- バージョン ID で固定した取り込みは再現される(バージョン ID の内容は不変であり、ロックレコードで検証する)。

## メディアタイプ {#미디어-타입}

- GEUL ドキュメントのメディアタイプは `application/vnd.geul` である。拡張子は `.geul` である。
- 標準ツリー `application/geul` に移しても、`application/vnd.geul` を引き続き受け付ける。

## 未解決の問題 {#열린-문제}

- 私設の公表・16 WORD Issuer・エアギャップ環境でバージョン ID が分岐したとき(同じバージョン ID で異なる内容)の扱い。
- Issuer 一覧 `issuers/` の HEAD 構成と、署名・チェーンの形式。ドメインのない Issuer(4 WORD)の名前規則、名前の紛争処理と長さの上限。
- 一覧が大きくなったとき、全体のチェーンの代わりに Merkle ログ(包含・一貫性の証明)へ移す時点と形式。
- 位置を提供する Issuer を HEAD に書く Meta。
