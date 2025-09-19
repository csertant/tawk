import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tawk_chat_stub.dart' if (dart.library.html) 'tawk_chat_web.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

/// Facade widget that uses a web-optimized DOM embed on Flutter Web, and a
/// WebView on other platforms.
class TawkChat extends StatelessWidget {
  final String propertyId;
  final double? initialHeight;

  const TawkChat({super.key, required this.propertyId, this.initialHeight});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return TawkChatWeb(propertyId: propertyId, initialHeight: initialHeight);
    }
    // Use a WebView-based implementation for non-web platforms.
    return _TawkChatMobile(
      propertyId: propertyId,
      initialHeight: initialHeight,
    );
  }
}

class _TawkChatMobile extends StatefulWidget {
  final String propertyId;
  final double? initialHeight;

  const _TawkChatMobile({required this.propertyId, this.initialHeight});

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

  String _buildTawkHtml(String propertyId) =>
      '''
<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>html,body{height:100%;margin:0;padding:0;}#tawk-container{height:100%;}</style>
  </head>
  <body>
    <div id="tawk-container"></div>
    <script type="text/javascript">
      var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
      (function(){
    var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
    s1.async=true;
    s1.src='https://embed.tawk.to/' + '$propertyId' + '/default';
    s1.charset='UTF-8';
        s1.setAttribute('crossorigin','*');
        s0.parentNode.insertBefore(s1,s0);
      })();
    </script>
  </body>
</html>
''';

  Future<void> _loadTawkHtml() async {
    final html = _buildTawkHtml(widget.propertyId);
    await _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.initialHeight;
    final webview = wv.WebViewWidget(controller: _controller);

    if (height != null) return SizedBox(height: height, child: webview);
    return SizedBox.expand(child: webview);
  }
}
