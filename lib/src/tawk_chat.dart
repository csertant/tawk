import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tawk_chat_stub.dart' if (dart.library.html) 'tawk_chat_web.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

/// A widget that embeds the tawk.to chat widget into your Flutter app.
///
/// On web platforms this widget injects the tawk.to script into the host
/// page's DOM. On non-web platforms it uses a [WebView] to load the same
/// script inside a minimal HTML page.
///
/// Required:
/// - [chatUrl]: the tawk.to chat URL for your chat.
///
/// Optional:
/// - [initialHeight]: a fixed height for the widget. If omitted the widget
///   expands to fill its parent.
///
/// Example:
/// ```dart
/// TawkChat(chatUrl: 'https://tawk.to/chat/<id>/<widget>')
/// ```
class TawkChat extends StatelessWidget {
  /// The full tawk chat URL to open (e.g. https://tawk.to/chat/&lt;id&gt;/&lt;widget&gt;).
  ///
  /// This package requires a direct chat URL. Provide a valid URL string.
  final String chatUrl;
  final double? initialHeight;

  const TawkChat({super.key, required this.chatUrl, this.initialHeight});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return TawkChatWeb(chatUrl: chatUrl, initialHeight: initialHeight);
    }
    // Use a WebView-based implementation for non-web platforms.
    return _TawkChatMobile(chatUrl: chatUrl, initialHeight: initialHeight);
  }
}

class _TawkChatMobile extends StatefulWidget {
  final String chatUrl;
  final double? initialHeight;

  const _TawkChatMobile({required this.chatUrl, this.initialHeight});

  @override
  State<_TawkChatMobile> createState() => _TawkChatMobileState();
}

class _TawkChatMobileState extends State<_TawkChatMobile> {
  late final wv.WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = wv.WebViewController()
      ..setJavaScriptMode(wv.JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    _loadTawkHtml();
  }

  String _buildTawkHtmlFromUrl(String chatUrl) =>
      '''
<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>html,body{height:100%;margin:0;padding:0;}#tawk-iframe{height:100%;width:100%;border:0;}</style>
  </head>
  <body>
    <iframe id="tawk-iframe" src="$chatUrl" frameborder="0" allow="clipboard-write; encrypted-media; fullscreen; geolocation;"></iframe>
  </body>
</html>
''';

  Future<void> _loadTawkHtml() async {
    await _controller.loadHtmlString(_buildTawkHtmlFromUrl(widget.chatUrl));
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.initialHeight;
    final webview = wv.WebViewWidget(controller: _controller);

    if (height != null) return SizedBox(height: height, child: webview);
    return SizedBox.expand(child: webview);
  }
}
