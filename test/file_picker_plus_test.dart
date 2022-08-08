import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker_plus/file_picker_plus.dart';
import 'package:file_picker_plus/file_picker_plus_platform_interface.dart';
import 'package:file_picker_plus/file_picker_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFilePickerPlusPlatform 
    with MockPlatformInterfaceMixin
    implements FilePickerPlusPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FilePickerPlusPlatform initialPlatform = FilePickerPlusPlatform.instance;

  test('$MethodChannelFilePickerPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFilePickerPlus>());
  });

  test('getPlatformVersion', () async {
    FilePickerPlus filePickerPlusPlugin = FilePickerPlus();
    MockFilePickerPlusPlatform fakePlatform = MockFilePickerPlusPlatform();
    FilePickerPlusPlatform.instance = fakePlatform;
  
    expect(await filePickerPlusPlugin.getPlatformVersion(), '42');
  });
}
