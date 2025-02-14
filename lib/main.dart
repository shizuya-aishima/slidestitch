import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/process_run.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SlideStitch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? inputDirectory;
  String? outputFile;
  bool isProcessing = false;

  Future<void> _selectInputDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: '入力フォルダを選択',
    );
    if (selectedDirectory != null) {
      setState(() {
        inputDirectory = selectedDirectory;
      });
    }
  }

  Future<void> _selectOutputFile() async {
    String? selectedDirectory = await FilePicker.platform.saveFile(
      dialogTitle: '出力ファイルを選択',
      fileName: 'merged.pptx',
      type: FileType.custom,
      allowedExtensions: ['pptx'],
    );
    if (selectedDirectory != null) {
      setState(() {
        outputFile = selectedDirectory;
      });
    }
  }

  Future<void> _mergePowerPoints() async {
    if (inputDirectory == null || outputFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('入力フォルダと出力ファイルを選択してください')),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      // PowerPointファイルを検索
      final directory = Directory(inputDirectory!);
      final files = directory
          .listSync()
          .where((file) =>
              file is File &&
              path.extension(file.path).toLowerCase() == '.pptx')
          .map((file) => file.path)
          .toList();

      if (files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PowerPointファイルが見つかりませんでした')),
        );
        return;
      }

      // PowerPointファイルをマージするコマンドを実行
      final shell = Shell();
      final command = '''
        powershell.exe -Command "
          \$powerPoint = New-Object -ComObject PowerPoint.Application;
          \$powerPoint.Visible = [Microsoft.Office.Core.MsoTriState]::msoFalse;
          \$presentation = \$powerPoint.Presentations.Open('${files[0]}');
          foreach(\$file in @('${files.skip(1).join("','")}')) {
            \$presentation.Windows[1].Activate();
            \$presentation.Slides.InsertFromFile(\$file, \$presentation.Slides.Count);
          }
          \$presentation.SaveAs('$outputFile');
          \$presentation.Close();
          \$powerPoint.Quit();
        "
      ''';
      await shell.run(command);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('マージが完了しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SlideStitch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('入力フォルダ:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            inputDirectory ?? '選択されていません',
                            style: TextStyle(
                              color: inputDirectory == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _selectInputDirectory,
                          child: const Text('選択'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('出力ファイル:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            outputFile ?? '選択されていません',
                            style: TextStyle(
                              color: outputFile == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _selectOutputFile,
                          child: const Text('選択'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isProcessing ? null : _mergePowerPoints,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: isProcessing
                  ? const CircularProgressIndicator()
                  : const Text(
                      'マージを実行',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
