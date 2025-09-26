// Shared helpers for building tawk embed script URLs and HTML.

/// Extracts the property id portion from a full Tawk chat URL.
///
/// For example, given `https://tawk.to/chat/<property>/<widget>` this
/// returns the `<property>` segment. Returns `null` if the URL cannot be
/// parsed.
String? getPropertyId(String chatUrl) {
  try {
    final parts = chatUrl.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return parts[parts.length - 2];
  } catch (_) {}
  return null;
}

/// Extracts the widget id portion from a full Tawk chat URL.
///
/// For example, given `https://tawk.to/chat/<property>/<widget>` this
/// returns the `<widget>` segment. Returns `null` if the URL cannot be
/// parsed.
String? getWidgetId(String chatUrl) {
  try {
    final parts = chatUrl.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isNotEmpty) return parts.last;
  } catch (_) {}
  return null;
}

/// Build a minimal HTML string that initializes the tawk API and loads
/// the embed script. This HTML is used by WebView-based platforms.
///
/// If the provided `chatUrl` cannot be parsed into a property/widget
/// pair the returned HTML contains an iframe pointing to the original
/// `chatUrl` as a fallback.
String buildTawkEmbedHtml(String chatUrl) {
  final property = getPropertyId(chatUrl);
  final widget = getWidgetId(chatUrl);
  if (property == null || widget == null) {
    // Fallback to iframe if parsing fails
    return '''<!doctype html>
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
  }

  return '''<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>html,body{height:100%;margin:0;padding:0;}</style>
    <script type="text/javascript">
      var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
      (function(){
        var s1=document.createElement('script'),s0=document.getElementsByTagName('script')[0];
        s1.async=true;
        s1.src='https://embed.tawk.to/$property/$widget';
        s1.charset='UTF-8';
        s1.setAttribute('crossorigin','*');
        s0.parentNode.insertBefore(s1,s0);
      })();
    </script>
  </head>
  <body>
  </body>
</html>
''';
}
