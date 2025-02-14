// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slidestitch/main.dart';

void main() {
  group('PowerPoint Merger Widget Tests', () {
    testWidgets('初期状態のUIテスト', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // アプリタイトルの確認
      expect(find.text('SlideStitch'), findsOneWidget); // AppBarのタイトルのみ

      // 初期状態のテキスト確認
      expect(find.text('入力フォルダ:'), findsOneWidget);
      expect(find.text('出力ファイル:'), findsOneWidget);
      expect(find.text('選択されていません'), findsNWidgets(2));

      // ボタンの存在確認
      expect(find.widgetWithText(ElevatedButton, '選択'), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'マージを実行'), findsOneWidget);
    });

    testWidgets('マージ実行ボタンのエラーメッセージテスト', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // マージ実行ボタンをタップ
      await tester.tap(find.widgetWithText(ElevatedButton, 'マージを実行'));
      await tester.pump();

      // エラーメッセージの確認
      expect(find.text('入力フォルダと出力ファイルを選択してください'), findsOneWidget);
    });
  });
}
