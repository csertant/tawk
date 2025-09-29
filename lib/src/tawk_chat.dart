import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tawk_chat_stub.dart' if (dart.library.html) 'tawk_chat_web.dart';
import 'tawk_chat_common.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

/// Controls chat UI: floating widget on web, WebView on mobile.
class TawkController {
  /// The chat URL from your Tawk.to dashboard.
  final String chatUrl;
  bool _isOpen = false;

  /// Creates controller with chat URL from Tawk.to dashboard.
  TawkController({required this.chatUrl});

  /// Opens chat interface.
  Future<void> open(BuildContext context) async {
    if (kIsWeb) {
      // For web, the embed script normally renders a floating widget.
      // If developers want a page, they can push their own route. Here we
      // provide no-op or could call JS interop if Tawk_API supports it.
      return;
    }

    if (_isOpen) {
      return;
    }
    _isOpen = true;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _TawkFullScreenPage(chatUrl: chatUrl)),
    );
    _isOpen = false;
  }

  /// Closes chat interface.
  void close(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.of(context).pop();
  }

  Future<bool> isOpen() async => _isOpen;

  /// Gets controller from nearest TawkChat ancestor.
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

/// Tawk.to chat integration widget.
///
/// Usage:
/// ```dart
/// TawkChat(
///   chatUrl: 'https://tawk.to/chat/property/widget',
///   child: MyApp(),
/// )
/// ```
class TawkChat extends StatefulWidget {
  /// Chat URL from Tawk.to dashboard (optional if controller provided).
  final String? chatUrl;

  /// Initial height for web widget placeholder.
  final double? initialHeight;

  /// Pre-configured controller (optional).
  final TawkController? controller;

  /// Child widget to wrap.
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

    // Some embed scripts perform UA sniffing or require a non-empty user
    // agent to run certain features. Set a conservative, modern UA string
    // to improve compatibility with tawk's embed scripts.
    try {
      _controller.setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/116.0.0.0 Mobile Safari/537.36',
      );
    } catch (_) {
      // setUserAgent may not be available on some platforms/versions; ignore.
    }
    // Set up navigation delegate for handling page lifecycle events
    _controller.setNavigationDelegate(
      wv.NavigationDelegate(
        onProgress: (progress) {
          /* Progress: $progress */
        },
        onPageStarted: (url) {
          /* Page started: $url */
        },
        onPageFinished: (url) {
          /* Page finished: $url */
        },
        onWebResourceError: (error) {
          /* Resource error: ${error.description} */
        },
      ),
    );

    _loadTawkHtml();
  }

  Future<void> _loadTawkHtml() async {
    // Attempt to navigate directly to the chat URL to ensure the WebView
    // has a proper HTTPS origin. This avoids localStorage access issues
    // that can occur when scripts are injected into about:blank contexts.
    try {
      // Load the chat page directly which contains the embedded widget
      final pageUrl = Uri.parse(widget.chatUrl);
      await _controller.loadRequest(pageUrl);
      return;
    } catch (_) {
      // Fallback: load HTML string with iframe wrapper
      try {
        final html = buildTawkEmbedHtml(widget.chatUrl);
        await _controller.loadHtmlString(html);
      } catch (e) {
        // If all else fails, this will be caught by the surrounding try-catch
        rethrow;
      }
    }
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
