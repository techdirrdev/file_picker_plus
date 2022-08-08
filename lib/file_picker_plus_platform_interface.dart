import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'file_picker_plus_method_channel.dart';

abstract class FilePickerPlusPlatform extends PlatformInterface {
  /// Constructs a FilePickerPlusPlatform.
  FilePickerPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static FilePickerPlusPlatform _instance = MethodChannelFilePickerPlus();

  /// The default instance of [FilePickerPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelFilePickerPlus].
  static FilePickerPlusPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FilePickerPlusPlatform] when
  /// they register themselves.
  static set instance(FilePickerPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
