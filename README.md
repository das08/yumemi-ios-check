# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

本プロジェクトは株式会社ゆめみ（以下弊社）が、弊社に iOS エンジニアを希望する方に出す課題のベースプロジェクトです。本課題が与えられた方は、下記の概要を詳しく読んだ上で課題を取り組んでください。

<details>
<summary>初期README</summary>

## アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。

![動作イメージ](README_Images/app.gif)

### 環境

- IDE：基本最新の安定版（本概要更新時点では Xcode 13.0）
- Swift：基本最新の安定版（本概要更新時点では Swift 5.5）
- 開発ターゲット：基本最新の安定版（本概要更新時点では iOS 15.0）
- サードパーティーライブラリーの利用：オープンソースのものに限り制限しない

### 動作

1. 何かしらのキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示

## 課題取り組み方法

Issues を確認した上、本プロジェクトを [**Duplicate** してください](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)（Fork しないようにしてください。必要ならプライベートリポジトリーにしても大丈夫です）。今後のコミットは全てご自身のリポジトリーで行ってください。

コードチェックの課題 Issue は全て [`課題`](https://github.com/yumemi/ios-engineer-codecheck/milestone/1) Milestone がついており、難易度に応じて Label が [`初級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A初級+milestone%3A課題)、[`中級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A中級+milestone%3A課題+) と [`ボーナス`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3Aボーナス+milestone%3A課題+) に分けられています。課題の必須／選択は下記の表とします：

|   | 初級 | 中級 | ボーナス
|--:|:--:|:--:|:--:|
| 新卒／未経験者 | 必須 | 選択 | 選択 |
| 中途／経験者 | 必須 | 必須 | 選択 |


課題 Issueをご自身のリポジトリーにコピーするGitHub Actionsをご用意しております。  
[こちらのWorkflow](./.github/workflows/copy-issues.yml)を[手動でトリガーする](https://docs.github.com/ja/actions/managing-workflow-runs/manually-running-a-workflow)ことでコピーできますのでご活用下さい。

課題が完成したら、リポジトリーのアドレスを教えてください。

## 参考記事

提出された課題の評価ポイントに関しては、[こちらの記事](https://qiita.com/lovee/items/d76c68341ec3e7beb611)に詳しく書かれてありますので、ぜひご覧ください。

</details>

## 開発環境
- M1 macOS Big Sur 11.4
- Xcode 13.2.1
- Swift 5.5.2
- CocoaPods 1.10.1

## 実行方法
1. 本レポジトリをクローンする
2. 依存関係をCocoaPodsでインストールする
```bash
pod install
```
3. `iOSEngineerCodeCheck.xcworkspace`を開く

## 使用したライブラリ
- [Alamofire](https://github.com/Alamofire/Alamofire)
  - GitHub APIにrequestを送るために採用
  - デフォルトのURLSessionより短いコードで書きやすいため
  - タイムアウトの設定やステータスコードによるバリデーションを簡潔にしたかったため

- [Alamofire Image](https://github.com/Alamofire/AlamofireImage)
  - レポジトリオーナーの画像を取得するために採用
  - 画像キャッシュを使いたかったため

- [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView)
  - APIコール中のブロッキング状態でローディング表示をさせるために採用
  - 数行のInitializerと1行の制御関数で表示・非表示が簡潔にできるため


## 採用したアーキテクチャ
- MVP(Model View Presenter)アーキテクチャ 
FatVCを回避するために採用した。MVPを採用した理由としては，アプリの仕様の観点からMVVCを採用するほど大規模ではないこと，またMVPでは元のコードに大きな変更を加えることなく責務を分離できるためである。  
さらに，Model，View，Presenterに分離したことでそれぞれのテストが書きやすくなった。

## こだわったポイント
- MVPアーキテクチャの採用
  - protocolを活用して仕様変更に強くし，後のUIUX改善で効率的にコードを書き換えることができた
- Alamofireでのエラーハンドリング
  - APIコール制限に引っかかった場合や，ネットワークに接続していない状況など，起こりうるエラーに対してenumでエラーハンドリングするようにした
- 検索画面のUI/UX改善
  - APIコール中に**ローディング表示**しUXを良くした
  - 検索を始める際に，前の検索結果を削除しUXを良くした
  - 取得エラーの場合に**アラートを表示**するようにした
  - 検索結果のtableViewのcellにユーザーが一番みたいであろう**star数を表示**した
  - GitHubAPIが日本語でも検索できる仕様なので，英数字以外も認めるようにした
- レポジトリ詳細画面のUI/UXの改善
  - リポジトリアイコンを**丸く**しモダンなデザインにした
  - Star数やFork数などを縦に表示して見やすくした
  - Star数やFork数などの左に**アイコンを表示**して視覚的にわかりやすくした
  - レポジトリの**主言語を色分け**してバッジラベルとして視覚的にわかりやすくした
  - レポジトリを**Safariで開ける**ボタンを追加した
  - レポジトリを**Shareできる**ように共有ボタンを追加した
  - レポジトリ名に応じてフォントサイズを可変にし，**見切れないように**した

## 既知のバグ
- GitHub APIのバグでstar数とwatcher数がおなじになっている

## 動作イメージ
<img src="/README_Images/appdemo.gif" width="250"/>