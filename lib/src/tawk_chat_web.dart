// Use dart:js_interop static interop for DOM access (modern recommended API).
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'tawk_chat_common.dart';

@JS()
@staticInterop
class Document {}

extension DocumentExtensions on Document {
  external Element? get head;
  external Element? get body;
  external Element? getElementById(String id);
  external Element createElement(String tag);
}

@JS()
@staticInterop
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

class TawkChatWeb extends StatefulWidget {
  final String chatUrl;
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

    final existing = doc.getElementById(id);
    if (existing != null) doc.body!.removeChild(existing);

    final div = doc.createElement('div');
    div.id = id;
    doc.body!.appendChild(div);

    // Inject the official tawk.to embed script instead of using an iframe.
    // The expected chatUrl is like: https://tawk.to/chat/<property>/<widgetId>
    // We convert it to the script src: https://embed.tawk.to/<property>/<widgetId>
    final propertyId = getPropertyId(widget.chatUrl);
    final widgetId = getWidgetId(widget.chatUrl);

    // Create a container div that the widget script can use (optional) and append it.
    final container = doc.createElement('div');
    container.id = '$id-container';
    div.appendChild(container);

    // If we couldn't parse property/widget ids, fall back to embedding the chatUrl in an iframe.
    if (propertyId == null || widgetId == null) {
      final iframe = doc.createElement('iframe');
      iframe.setAttribute('src', widget.chatUrl);
      iframe.setAttribute('style', 'width:100%;height:100%;border:0;');
      div.appendChild(iframe);
      return;
    }

    // Use the same HTML builder as the WebView implementation and inject its script.
    final loader = doc.createElement('script');
    loader.setAttribute('src', 'https://embed.tawk.to/$propertyId/$widgetId');
    loader.setAttribute('async', 'true');
    loader.setAttribute('type', 'text/javascript');
    loader.setAttribute('crossorigin', '*');

    // Also inject an inline initializer to set Tawk_API and Tawk_LoadStart.
    final init = doc.createElement('script');
    init.setAttribute('type', 'text/javascript');
    try {
      init.setAttribute(
        'text',
        "var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();",
      );
    } catch (_) {
      // ignore if not supported; loader will still load the widget
    }

    div.appendChild(init);
    div.appendChild(loader);
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
