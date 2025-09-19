// Use dart:js_interop static interop for DOM access (modern recommended API).
import 'dart:js_interop';
import 'package:flutter/material.dart';

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
  final String propertyId;
  final double? initialHeight;

  const TawkChatWeb({super.key, required this.propertyId, this.initialHeight});

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
    final id = 'flutter-tawk-${widget.propertyId}';
    _containerId = id;

    final existing = doc.getElementById(id);
    if (existing != null) doc.body!.removeChild(existing);

    final div = doc.createElement('div');
    div.id = id;
    doc.body!.appendChild(div);

    final script = doc.createElement('script');
    script.type = 'text/javascript';
    script.async = true;
    script.src = 'https://embed.tawk.to/${widget.propertyId}/default';
    script.setAttribute('crossorigin', '*');

    doc.head!.appendChild(script);
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
