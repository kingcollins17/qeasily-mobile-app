import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/provider/plan_provider.dart';

import 'package:webview_flutter/webview_flutter.dart';

class BuyPackageScreen extends StatefulWidget {
  const BuyPackageScreen({super.key, required this.data});
  final SubscriptionSessionData data;

  @override
  State<BuyPackageScreen> createState() => _BuyPackageScreenState();
}

class _BuyPackageScreenState extends State<BuyPackageScreen> {
  final webviewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState() {
    super.initState();
    webviewController
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (request) {
        if (request.url.contains('qeasily')) {
          context.go('/home/transactions');
          return NavigationDecision.prevent;
        } else {
          return NavigationDecision.navigate;
        }
      }))
      ..loadRequest(Uri.parse(widget.data.authorizationUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: WebViewWidget(controller: webviewController),
    );
  }
}
