import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker_plus/file_picker_plus_method_channel.dart';

void main() {
  MethodChannelFilePickerPlus platform = MethodChannelFilePickerPlus();
  const MethodChannel channel = MethodChannel('file_picker_plus');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
