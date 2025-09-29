// Use dart:js_interop static interop for DOM access (modern recommended API).
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
  external String? get id;
  external Element appendChild(Element child);
  external Element removeChild(Element child);
  external void setAttribute(String name, String value);
  external set src(String v);
  external set async(bool v);
  external set type(String v);
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

  Document get doc => _document!;

  @override
  void initState() {
    super.initState();
    _attachTawk();
  }

  @override
  void dispose() {
    if (_containerId != null) {
      final existing = doc.getElementById(_containerId!);
      if (existing != null) doc.body!.removeChild(existing);
    }
    super.dispose();
  }

  void _attachTawk() {
    final id = 'flutter-tawk-${widget.chatUrl.hashCode}';
    _containerId = id;

    // Remove any existing instance
    final existing = doc.getElementById(id);
    if (existing != null) {
      try {
        doc.body!.removeChild(existing);
      } catch (e) {
        // Element might have been removed already, ignore
      }
    }

    final div = doc.createElement('div');
    div.id = id;
    doc.body!.appendChild(div);

    final embedSrc = getEmbedScriptSrc(widget.chatUrl);

    if (embedSrc == null) {
      // Fallback: create iframe with the chat URL directly
      final iframe = doc.createElement('iframe');
      final html = buildIframeHtml(widget.chatUrl);
      iframe.setAttribute('srcdoc', html);
      iframe.setAttribute('style', 'width:100%;height:100%;border:0;');
      div.appendChild(iframe);
      return;
    }

    // Create container for the chat widget
    final container = doc.createElement('div');
    container.id = '$id-container';
    div.appendChild(container);

    // Inject the official Tawk.to script using the IIFE pattern
    final script = doc.createElement('script');
    script.setAttribute('type', 'text/javascript');
    try {
      script.setAttribute('text', getTawkScriptContent(embedSrc));
    } catch (e) {
      // Fallback to separate script elements if text attribute doesn't work
      final init = doc.createElement('script');
      init.setAttribute(
        'text',
        "var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();",
      );
      final loader = doc.createElement('script');
      loader.setAttribute('src', embedSrc);
      loader.setAttribute('async', 'true');
      loader.setAttribute('type', 'text/javascript');
      loader.setAttribute('crossorigin', '*');
      div.appendChild(init);
      div.appendChild(loader);
      return;
    }
    div.appendChild(script);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.initialHeight;
    final placeholder = Container(
      color: Colors.transparent,
      child: const Center(child: Text('Tawk chat (web)')),
    );

    if (height != null) return SizedBox(height: height, child: placeholder);
    return SizedBox.expand(child: placeholder);
  }
}
