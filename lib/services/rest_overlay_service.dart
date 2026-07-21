import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

/// Controls fullscreen always-on-top rest break overlay window flags.
class RestOverlayService extends ChangeNotifier {
  bool _isVisible = false;
  bool _isTransitioning = false;
  Rect? _savedBounds;
  bool _wasAlwaysOnTop = false;

  bool get isVisible => _isVisible;

  Future<void> show() async {
    if (_isVisible || _isTransitioning) return;
    _isTransitioning = true;

    try {
      _savedBounds = await windowManager.getBounds();
      _wasAlwaysOnTop = await windowManager.isAlwaysOnTop();

      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setFullScreen(true);

      _isVisible = true;
      notifyListeners();
    } catch (e) {
      print('Error showing rest overlay: $e');
      await _restoreWindowFlagsBestEffort();
    } finally {
      _isTransitioning = false;
    }
  }

  Future<void> hide() async {
    if (!_isVisible || _isTransitioning) return;
    _isTransitioning = true;

    try {
      await _restoreWindowFlagsBestEffort();
    } catch (e) {
      print('Error hiding rest overlay: $e');
      await _forceClearOverlayFlags();
    } finally {
      _isVisible = false;
      _isTransitioning = false;
      notifyListeners();
    }
  }

  Future<void> _restoreWindowFlagsBestEffort() async {
    try {
      await windowManager.setFullScreen(false);
    } catch (_) {}
    try {
      await windowManager.setAlwaysOnTop(_wasAlwaysOnTop);
    } catch (_) {
      await _forceClearOverlayFlags();
    }
    final bounds = _savedBounds;
    if (bounds != null) {
      try {
        await windowManager.setBounds(bounds);
      } catch (_) {}
    }
    _savedBounds = null;
  }

  Future<void> _forceClearOverlayFlags() async {
    try {
      await windowManager.setFullScreen(false);
    } catch (_) {}
    try {
      await windowManager.setAlwaysOnTop(false);
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_isVisible) {
      _forceClearOverlayFlags();
    }
    super.dispose();
  }
}
