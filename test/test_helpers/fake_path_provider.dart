import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// Routes path_provider's app-directory lookups to a test-controlled temp
/// folder, so backup/restore code (which resolves file paths through
/// path_provider) can run under `flutter test` without a real platform.
class FakePathProviderPlatform extends PathProviderPlatform {
  FakePathProviderPlatform(this.root);

  final String root;

  @override
  Future<String?> getApplicationDocumentsPath() async => root;

  @override
  Future<String?> getApplicationSupportPath() async => root;
}
