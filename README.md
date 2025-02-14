# SlideStitch (スライドステッチ)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

PowerPointプレゼンテーションを簡単に結合できるデスクトップアプリケーションです。

![SlideStitch Screenshot](docs/images/screenshot.png)

## 概要

SlideStitchは、複数のPowerPointファイルを1つのプレゼンテーションにマージするためのシンプルなGUIツールです。ドラッグ＆ドロップで簡単に操作でき、プレゼンテーション資料の統合作業を効率化します。

## 機能

- 複数のPowerPointファイル（.pptx）を1つのファイルにマージ
- シンプルで使いやすいGUIインターフェース
- ドラッグ＆ドロップに対応した入力フォルダ選択
- カスタム出力ファイル名の指定
- 処理中のプログレス表示

## 必要要件

- Windows 10以降
- Microsoft PowerPoint
- [Flutter](https://flutter.dev/) (開発時のみ)

## インストール

```bash
git clone https://github.com/shizuya-aishima/slidestitch.git
cd slidestitch
flutter pub get
```

## インストール方法

1. リリースページから最新の`SlideStitch.msix`をダウンロード
2. ダウンロードしたファイルを実行してインストール
3. スタートメニューから「SlideStitch」を起動

## 使用方法

1. 「入力フォルダ」ボタンをクリックして、マージしたいPowerPointファイルが含まれるフォルダを選択
2. 「出力ファイル」ボタンをクリックして、マージ後のファイルの保存先と名前を指定
3. 「マージを実行」ボタンをクリックして処理を開始
4. 処理が完了すると、指定した場所にマージされたファイルが保存されます

## 開発者向け情報

### 環境構築

```bash
# Flutterをインストール
flutter pub get
```

### テストの実行

```bash
flutter test
```

### ビルド方法

```bash
flutter build windows
flutter pub run msix:create
```

## ライセンス

MIT License

## 作者

Shizuya Aishima ([@shizuya-aishima](https://github.com/shizuya-aishima))

## 注意事項

- マージ処理中はPowerPointを操作しないでください
- 大量のスライドをマージする場合は、処理に時間がかかる場合があります
- 入力フォルダ内の全ての.pptxファイルが処理対象となります
