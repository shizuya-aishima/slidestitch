import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  group('PowerPoint Merger Unit Tests', () {
    late Directory tempDir;
    late String outputPath;

    setUp(() async {
      // テスト用の一時ディレクトリを作成
      tempDir = await Directory.systemTemp.createTemp('ppt_merger_test_');
      outputPath = path.join(tempDir.path, 'merged.pptx');
    });

    tearDown(() async {
      // テスト後のクリーンアップ
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('空のディレクトリのテスト', () {
      final directory = Directory(tempDir.path);
      final files = directory
          .listSync()
          .where((file) =>
              file is File &&
              path.extension(file.path).toLowerCase() == '.pptx')
          .toList();

      expect(files.isEmpty, true);
    });

    test('PowerPointファイル拡張子の判定テスト', () {
      final validExtensions = [
        'test.pptx',
        'TEST.PPTX',
        'test.PPTX',
        'complex name.pptx'
      ];
      final invalidExtensions = [
        'test.ppt',
        'test.doc',
        'test.docx',
        'test.txt',
        'test'
      ];

      for (final fileName in validExtensions) {
        expect(
          path.extension(fileName).toLowerCase() == '.pptx',
          true,
          reason: '$fileName should be recognized as a PowerPoint file',
        );
      }

      for (final fileName in invalidExtensions) {
        expect(
          path.extension(fileName).toLowerCase() == '.pptx',
          false,
          reason: '$fileName should not be recognized as a PowerPoint file',
        );
      }
    });

    test('出力パスの生成テスト', () {
      expect(outputPath.endsWith('.pptx'), true);
      expect(path.basename(outputPath), 'merged.pptx');
    });
  });
}
