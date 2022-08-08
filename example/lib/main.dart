import 'package:file_picker_plus/file_data.dart';
import 'package:file_picker_plus/file_picker.dart';
import 'package:file_picker_plus/files.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FileData _fileData = FileData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FilePicker(context: context, fileData: _fileData, onSelected: (fileData) {
          _fileData = fileData;
          setState(() {});
          print(fileData.filePath);
        }),
        /*body: ElevatedButton(onPressed: () {
          _camera();
        }, child: Text("Camera")),*/
      ),
    );
  }

  _camera() async {
    await Files.cameraPicker(fileData: _fileData, crop: true, onSelected: (fileData) {
      print(fileData.filePath);
    });
  }
}
