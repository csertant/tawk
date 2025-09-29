// Shared helpers for building tawk embed script URLs and HTML.
import 'package:flutter/foundation.dart';

/// Converts chat URL to embed script URL, or null if invalid.
String? getEmbedScriptSrc(String chatUrl) {
  final prop = getPropertyId(chatUrl);
  final wid = getWidgetId(chatUrl);
  if (prop == null || wid == null) return null;
  return 'https://embed.tawk.to/$prop/$wid';
}

/// Extracts property ID from chat URL.
String? getPropertyId(String chatUrl) {
  try {
    final uri = Uri.tryParse(chatUrl);
    if (uri == null) return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    // Expecting .../chat/<property>/<widget>
    final chatIndex = segments.indexOf('chat');
    if (chatIndex >= 0 && segments.length > chatIndex + 1) {
      return segments[chatIndex + 1];
    }
  } catch (_) {}
  return null;
}

/// Extracts widget ID from chat URL.
String? getWidgetId(String chatUrl) {
  try {
    final uri = Uri.tryParse(chatUrl);
    if (uri == null) return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    // widget id is the last path segment when URL matches /chat/<property>/<widget>
    if (segments.length >= 3 && segments[segments.length - 3] == 'chat') {
      return segments.last;
    }
  } catch (_) {}
  return null;
}

/// Builds HTML page with iframe for mobile WebView fallback.
String buildIframeHtml(String chatUrl, {String? allowAttrs}) {
  final allow =
      allowAttrs ??
      'clipboard-write; encrypted-media; fullscreen; geolocation; microphone; camera';
  return '''<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>html,body{height:100%;margin:0;padding:0;}#tawk-iframe{height:100%;width:100%;border:0;}</style>
  </head>
  <body>
    <iframe id="tawk-iframe" src="$chatUrl" frameborder="0" allow="$allow"></iframe>
  </body>
</html>
''';
}

/// Builds HTML with Tawk.to script injection for web platforms.
String _buildWebScriptHtml(String embedSrc) {
  return '''<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>
  <body>
    <div id="tawk-root"></div>
    <!--Start of Tawk.to Script-->
    <script type="text/javascript">
    var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
    (function(){
    var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
    s1.async=true;
    s1.src='$embedSrc';
    s1.charset='UTF-8';
    s1.setAttribute('crossorigin','*');
    s0.parentNode.insertBefore(s1,s0);
    })();
    </script>
    <!--End of Tawk.to Script-->
  </body>
</html>
''';
}

/// Builds platform-appropriate HTML: script injection for web, iframe for mobile.
String buildTawkEmbedHtml(String chatUrl) {
  final embedSrc = getEmbedScriptSrc(chatUrl);
  if (kIsWeb) {
    if (embedSrc == null) return buildIframeHtml(chatUrl);
    return _buildWebScriptHtml(embedSrc);
  }

  // Non-web: prefer iframe wrapper so the embed runs under the remote origin.
  return buildIframeHtml(chatUrl);
}
