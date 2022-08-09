import 'file_picker_plus_platform_interface.dart';

class FilePickerPlus {
  Future<String?> getPlatformVersion() {
    return FilePickerPlusPlatform.instance.getPlatformVersion();
  }
}
