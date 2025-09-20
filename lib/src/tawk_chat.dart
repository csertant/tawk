import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tawk_chat_stub.dart' if (dart.library.html) 'tawk_chat_web.dart';
import 'tawk_chat_common.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

/// Controller that manages opening/closing the chat UI.
class TawkController {
  final String chatUrl;
  bool _isOpen = false;

  TawkController({required this.chatUrl});

  /// Open the chat UI. On mobile this pushes a full-screen WebView route.
  /// On web this will attempt to call the embed API or focus the floating widget.
  Future<void> open(BuildContext context) async {
    if (kIsWeb) {
      // For web, the embed script normally renders a floating widget.
      // If developers want a page, they can push their own route. Here we
      // provide no-op or could call JS interop if Tawk_API supports it.
      return;
    }

    if (_isOpen) return;
    _isOpen = true;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _TawkFullScreenPage(chatUrl: chatUrl)),
    );
    _isOpen = false;
  }

  /// Close the chat. Caller should provide a context with an active Navigator.
  void close(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.of(context).pop();
  }

  Future<bool> isOpen() async => _isOpen;

  /// Convenience accessor to obtain the controller via context.
  ///
  /// Finds the nearest ancestor `TawkChat` widget and returns its controller.
  static TawkController of(BuildContext context) {
    final state = context.findAncestorStateOfType<_TawkChatState>();
    if (state == null) {
      throw FlutterError(
        'No TawkChat found in context. Make sure you placed a TawkChat above the calling widget.',
      );
    }
    return state._controller;
  }
}

/// Inherited widget exposing the [TawkController] to descendants.
// Controller provider removed: TawkChat now exposes its controller via its State.

/// Public widget that owns (or accepts) a [TawkController] and exposes it
/// via [TawkChatControllerProvider]. On web it installs the embed script.
class TawkChat extends StatefulWidget {
  /// The chat URL (e.g. https://tawk.to/chat/&lt;id&gt;/&lt;widget&gt;). Optional if
  /// a [TawkController] with a chatUrl is provided.
  final String? chatUrl;
  final double? initialHeight;
  final TawkController? controller;

  /// Optional child widget to render. If provided, TawkChat will render the
  /// child and keep the web helper offstage to install the script without
  /// affecting layout.
  final Widget? child;

  const TawkChat({
    super.key,
    this.chatUrl,
    this.initialHeight,
    this.controller,
    this.child,
  }) : assert(
         chatUrl != null || controller != null,
         'Either chatUrl or controller with chatUrl must be provided',
       );

  @override
  State<TawkChat> createState() => _TawkChatState();
}

class _TawkChatState extends State<TawkChat> {
  late final TawkController _controller;
  // (no local flag needed currently)

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      // If both controller and chatUrl were provided, ensure they match.
      if (widget.chatUrl != null && widget.chatUrl != _controller.chatUrl) {
        throw ArgumentError.value(
          widget.chatUrl,
          'chatUrl',
          'chatUrl must match controller.chatUrl when both are provided',
        );
      }
    } else {
      // widget.chatUrl is non-null because of the constructor assert above.
      _controller = TawkController(chatUrl: widget.chatUrl!);
    }
  }

  @override
  void dispose() {
    // Controller has no heavy resources; if we created it locally we simply
    // drop references. If we later add WebView reuse, handle cleanup here.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // On web: keep existing behavior (inject script / floating widget) by
    // returning the web-specific widget inside the provider.
    final effectiveUrl = widget.chatUrl ?? _controller.chatUrl;

    final webHelper = TawkChatWeb(
      chatUrl: effectiveUrl,
      initialHeight: widget.initialHeight,
    );

    if (widget.child != null) {
      // Render the provided child and keep web helper offstage so it can
      // attach scripts without affecting layout.
      return Stack(
        children: [
          widget.child!,
          Offstage(child: webHelper),
        ],
      );
    }

    return kIsWeb ? webHelper : const SizedBox.shrink();
  }
}

/// Full-screen page used on mobile to show the tawk embed inside a WebView.
class _TawkFullScreenPage extends StatefulWidget {
  final String chatUrl;

  const _TawkFullScreenPage({required this.chatUrl});

  @override
  State<_TawkFullScreenPage> createState() => _TawkFullScreenPageState();
}

class _TawkFullScreenPageState extends State<_TawkFullScreenPage> {
  late final wv.WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = wv.WebViewController()
      ..setJavaScriptMode(wv.JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    _loadTawkHtml();
  }

  Future<void> _loadTawkHtml() async {
    final html = buildTawkEmbedHtml(widget.chatUrl);
    await _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tawk Chat'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: wv.WebViewWidget(controller: _controller),
    );
  }
}
