import 'package:flutter/material.dart';

/// Stub implementation used on non-web platforms when the web-specific
/// DOM-based TawkChat is not available. This ensures conditional imports
/// compile across platforms.
class TawkChatWeb extends StatelessWidget {
  final String chatUrl;
  final double? initialHeight;

  const TawkChatWeb({super.key, required this.chatUrl, this.initialHeight});

  @override
  Widget build(BuildContext context) {
    // This stub shouldn't be used on non-web platforms. Provide a placeholder.
    return const SizedBox.shrink();
  }
}
