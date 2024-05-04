import 'package:flutter/services.dart';

class Toast {
  static const _platform = const MethodChannel('com.safeKeeper');
  Toast(String message) {
    _showToast(message);
  }

  Future<Null> _showToast(String message) async {
    await _platform.invokeMethod('toast', {'message': message});
  }
}
