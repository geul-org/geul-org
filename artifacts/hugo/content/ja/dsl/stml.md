---
title: "STML — SSOT Template Markup Language"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "フレームワーク非依存のUI宣言言語。HTML5 data-*属性でページが何を表示し何を行うかを定義し、OpenAPI対比シンボリック検証後にReactコードを生成する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — フレームワーク非依存のUI宣言。

フロントエンドコードは2つのものを混ぜている：**あなたの決定**と**フレームワーク配線**。どのAPIを呼ぶか、どのフィールドを見せるか、どの順序で、どの条件で——これらの決定がReact hooksやVue composablesの中に埋もれる。フレームワークを変えたりリファクタリングすると、決定が再解釈されたり失われたりする。

STMLはこれを分離する。決定は`data-*`属性付きの標準HTMLに残り、フレームワーク配線は生成または委譲される。

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHubリポジトリ</a>

## 構造

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  あなたの決定。フレームワーク非依存。
│  何を取得し、表示し、送信するか  │  どんなリライトも生き残る。
├─────────────────────────────────┤
│  コード生成 / LLM               │  フレームワーク配線を生成。
│  React, Vue, Svelte, 何でも     │  交換可能。
├─────────────────────────────────┤
│  ランタイム (artifacts/)         │  React TSX, Vue SFC など。
│  フック、状態、レンダリング      │  生成物。編集しない。
└─────────────────────────────────┘
```

## 保存されるもの

STML HTMLのすべてがユーザーの決定である：

- **どのAPIエンドポイント**を呼ぶか (`data-fetch`, `data-action`)
- **どのフィールド**を表示・収集するか (`data-bind`, `data-field`)
- **どの順序**で要素が現れるか (DOM構造)
- **どう見えるか** (Tailwindクラス、HTMLタグ)
- **どのテキスト**をユーザーが見るか (見出し、プレースホルダー、ボタンラベル)
- **どの条件**が可視性を制御するか (`data-state`)
- **どのコンポーネント**が特殊UXを処理するか (`data-component`)
- **リストの動作** — ページネーション、ソート、フィルタリング

Reactでもない。Vueでもない。ページが何をするか、標準HTML5で宣言したものだ。

## 例

```html
<main class="max-w-4xl mx-auto p-6">
  <h1 class="text-2xl font-bold mb-6">予約一覧</h1>

  <section data-fetch="ListMyReservations"
           data-paginate data-sort="StartAt:desc" data-filter="Status">
    <ul data-each="reservations" class="space-y-3">
      <li class="flex justify-between p-4 border rounded">
        <span data-bind="RoomID" class="font-semibold"></span>
        <span data-bind="Status" class="text-sm text-gray-500"></span>
      </li>
    </ul>
    <p data-state="reservations.empty" class="text-gray-400">予約はありません</p>
  </section>

  <div data-action="CreateReservation">
    <input data-field="RoomID" type="number" placeholder="部屋番号" />
    <button type="submit">予約</button>
  </div>
</main>
```

同じファイルから異なるターゲットを生成できる：

| ターゲット | 方法 |
|---|---|
| React TSX | `stml gen`（内蔵の決定的コード生成） |
| Vue SFC | STML + OpenAPIをLLMに：「Vueで実装して」 |
| Svelte | STML + OpenAPIをLLMに：「Svelteで実装して」 |
| Flutter | STML + OpenAPIをLLMに：「Flutterで実装して」 |

決定は保存される。フレームワーク配線だけが変わる。

## 検証

内蔵バリデーターがコード生成前にSTMLをOpenAPI対比で交差検証する：

- operationIdが存在するか？HTTPメソッドは正しいか？
- リクエストフィールド、レスポンスフィールド、パラメーターがスキーマと一致するか？
- ソート/フィルター/インクルードカラムが許可リスト内にあるか？
- 参照されたコンポーネントが存在するか？

フロントエンド-APIの不一致をランタイムではなくCI時に捕捉する。

```bash
stml validate specs/my-project    # OpenAPI対比12のシンボリック検査
```

## data-* 属性

| 属性 | 宣言内容 |
|---|---|
| `data-fetch` | GETエンドポイントからデータをロード |
| `data-action` | POST/PUT/DELETEエンドポイントにデータを送信 |
| `data-field` | リクエストボディフィールドを収集 |
| `data-bind` | レスポンスフィールドを表示 |
| `data-param-*` | パス/クエリパラメーターが必要な操作 |
| `data-each` | 配列フィールドを反復 |
| `data-state` | 条件付き表示 |
| `data-component` | カスタムコンポーネントに委譲 |
| `data-paginate` | ページネーション付きリスト |
| `data-sort` | ソート可能リスト（デフォルトカラムと方向） |
| `data-filter` | フィルター可能リスト（どのカラム） |
| `data-include` | 関連リソースを含むクエリ |

## ライセンス

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
