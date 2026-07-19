import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appVersionLabelProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  if (info.buildNumber.isEmpty) {
    return 'v${info.version}';
  }
  return 'v${info.version}+${info.buildNumber}';
});
