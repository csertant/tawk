import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'tawk_chat_common.dart';

@JS()
@staticInterop

/// DOM document interface for script injection.
class Document {}

extension DocumentExtensions on Document {
  external Element? get head;
  external Element? get body;
  external Element? getElementById(String id);
  external Element createElement(String tag);
}

@JS()
@staticInterop

/// DOM element interface for script manipulation.
class Element {}

extension ElementExtensions on Element {
  external set id(String id);
  external String get id;
  external Element appendChild(Element child);
  external Element removeChild(Element child);
  external void setAttribute(String name, String value);
  external set textContent(String content);
}

@JS('document')
external Document? get _document;

/// Web chat widget that injects Tawk.to script.
class TawkChatWeb extends StatefulWidget {
  /// Chat URL from Tawk.to dashboard.
  final String chatUrl;

  /// Placeholder height (null = expand).
  final double? initialHeight;

  const TawkChatWeb({super.key, required this.chatUrl, this.initialHeight});

  @override
  State<TawkChatWeb> createState() => _TawkChatWebState();
}

class _TawkChatWebState extends State<TawkChatWeb> {
  String? _containerId;

  Document get document => _document!;

  @override
  void initState() {
    super.initState();
    _attachTawk();
  }

  @override
  void dispose() {
    if (_containerId != null) {
      final existing = document.getElementById(_containerId!);
      if (existing != null) document.body!.removeChild(existing);
    }
    super.dispose();
  }

  void _attachTawk() {
    final id = 'tawk-${widget.chatUrl.hashCode}';
    _containerId = id;

    // Remove any existing instance
    final existing = document.getElementById(id);
    if (existing != null) {
      try {
        document.body!.removeChild(existing);
      } catch (e) {
        // Element might have been removed already, ignore
      }
    }

    final embedSrc = getEmbedScriptSrc(widget.chatUrl);

    if (embedSrc == null) {
      // Fallback: create iframe with the chat URL directly
      final div = document.createElement('div');
      div.id = id;
      final iframe = document.createElement('iframe');
      final html = buildIframeHtml(widget.chatUrl);
      iframe.setAttribute('srcdoc', html);
      iframe.setAttribute('style', 'width:100%;height:100%;border:0;');
      div.appendChild(iframe);
      document.body!.appendChild(div);
      return;
    }

    // Inject the script directly into the head (standard Tawk approach)
    final script = document.createElement('script');
    script.setAttribute('type', 'text/javascript');
    try {
      script.textContent = getTawkScriptContent(embedSrc);
      document.head!.appendChild(script);
    } catch (e) {
      // Fallback to separate script elements
      final init = document.createElement('script');
      init.setAttribute('type', 'text/javascript');
      init.textContent =
          "var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();";

      final loader = document.createElement('script');
      loader.setAttribute('src', embedSrc);
      loader.setAttribute('async', 'true');
      loader.setAttribute('type', 'text/javascript');
      loader.setAttribute('crossorigin', '*');
      document.head!.appendChild(init);
      document.head!.appendChild(loader);
    }

    // Create a marker div for cleanup
    final div = document.createElement('div');
    div.id = id;
    div.setAttribute('style', 'display:none;');
    document.body!.appendChild(div);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.initialHeight;
    final placeholder = Container(
      color: Colors.transparent,
      child: const Center(child: Text('Tawk chat (web)')),
    );
    return SizedBox(height: height, child: placeholder);
  }
}
