import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'file_picker_plus_platform_interface.dart';

/// An implementation of [FilePickerPlusPlatform] that uses method channels.
class MethodChannelFilePickerPlus extends FilePickerPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('file_picker_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
