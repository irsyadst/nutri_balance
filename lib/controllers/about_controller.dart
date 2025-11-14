// lib/controllers/about_controller.dart

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutController with ChangeNotifier {
  String _version = 'Loading...';
  String get version => _version;

  AboutController() {
    _loadAppVersion();
  }
  Future<void> _loadAppVersion() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      _version = 'Versi ${info.version} (${info.buildNumber})';
    } catch (e) {
      _version = 'Gagal memuat versi';
    }
    notifyListeners();
  }
}