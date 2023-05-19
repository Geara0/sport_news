import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewInterface extends StatefulWidget {
  const WebViewInterface({
    required this.controller,
    super.key,
  });

  final WebViewController controller;

  @override
  State<WebViewInterface> createState() => _WebViewInterfaceState();
}

class _WebViewInterfaceState extends State<WebViewInterface> {
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => loadingPercentage = 0),
          onProgress: (progress) =>
              setState(() => loadingPercentage = progress),
          onPageFinished: (url) => setState(() => loadingPercentage = 100),
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // without await to load page on the go
        widget.controller.runJavaScript('history.back()');
        return false;
      },
      child: Stack(
        children: [
          WebViewWidget(controller: widget.controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(value: loadingPercentage / 100.0),
        ],
      ),
    );
  }
}
