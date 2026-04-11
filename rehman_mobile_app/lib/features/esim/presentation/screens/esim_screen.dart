import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';

class EsimScreen extends StatefulWidget {
  const EsimScreen({super.key});

  @override
  State<EsimScreen> createState() => _EsimScreenState();
}

class _EsimScreenState extends State<EsimScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  static const String _esimUrl =
      'https://montyesim.com/shop-plans/?affiliate_id=68da47325192e70241e46a5e&_branch_match_id=994641568405144969&utm_campaign=affiliate_campaign&utm_medium=68da47325192e70241e46a5e&_branch_referrer=H4sIAAAAAAAAA8soKSkottLXz83PK6lMLc7M1UssKNDLyczL1veICMgvCAxONg1Psq8rSk1LLSrKzEuPTyrKLy9OLbJ1zijKz00FAF%2Blb6JAAAAA';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _isLoading = true),
        onPageFinished: (_) => setState(() => _isLoading = false),
      ))
      ..loadRequest(Uri.parse(_esimUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: AppBackButton(),
        title: Text('eSIM', style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ],
      ),
    );
  }
}
