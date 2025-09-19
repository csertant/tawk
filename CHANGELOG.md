## 0.1.0 - Initial release (unreleased)

### Added

- Basic `TawkChat` widget that embeds a tawk.to chat.
	- Web: injects the tawk.to script into the host page using `dart:js_interop`.
	- Mobile/Desktop: uses `webview_flutter` to host the tawk.to embed inside a minimal HTML page.
- Example app in `example/` demonstrating usage.
- Basic unit/widget tests in `test/` and example tests in `example/test/`.

### Notes

- This is the initial release; please test the example on web and mobile manually. Future releases will add a controller API, event callbacks, and an inline HtmlElementView web example.

