import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A simple widget that loads a tawk.to chat instance inside a WebView.
///
/// Provide your tawkToPropertyId (widget ID) to display the chat. Example:
/// `TawkChat(propertyId: 'your_property_id')`.
class TawkChat extends StatefulWidget {
  /// The tawk.to property/widget id. This is the identifier used in the
  /// tawk.to embed script.
  final String propertyId;

  /// The initial height for the chat container. The widget will expand to
  /// fill its parent by default.
  final double? initialHeight;

  const TawkChat({super.key, required this.propertyId, this.initialHeight});

  @override
  State<TawkChat> createState() => _TawkChatState();
}

class _TawkChatState extends State<TawkChat> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Platform-specific WebView setup is left to the plugin defaults.

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    // Load the HTML that injects the tawk.to script
    _loadTawkHtml();
  }

  String _buildTawkHtml(String propertyId) {
    // Minimal tawk.to embed HTML. We load it as a data URI to avoid
    // navigation and to allow controlling CSS.
    return '''
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
  }

  Future<void> _loadTawkHtml() async {
    final html = _buildTawkHtml(widget.propertyId);
    await _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.initialHeight;
    final webview = WebViewWidget(controller: _controller);

    if (height != null) {
      return SizedBox(height: height, child: webview);
    }
    return SizedBox.expand(child: webview);
  }
}
