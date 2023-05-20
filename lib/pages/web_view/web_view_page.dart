import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    required this.uri,
    super.key,
  });

  final Uri uri;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final InAppWebViewController _controller;
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // without await to load page on the go
        _controller.goBack();
        return false;
      },
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: widget.uri),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  javaScriptEnabled: true,
                ),
              ),
              onWebViewCreated: (controller) => _controller = controller,
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              onProgressChanged: (controller, progress) =>
                  setState(() => loadingPercentage = progress),
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(value: loadingPercentage / 100.0),
          ],
        ),
      ),
    );
  }
}
