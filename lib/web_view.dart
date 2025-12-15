// ignore_for_file: deprecated_member_use, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BoiAcheWebViewApp extends StatefulWidget {
  const BoiAcheWebViewApp({super.key});

  @override
  State<BoiAcheWebViewApp> createState() => _BoiAcheWebViewAppState();
}

class _BoiAcheWebViewAppState extends State<BoiAcheWebViewApp> {
  int _currentIndex = 0;
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse('https://boiache.com/'));
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  Future<void> _refreshPage() async {
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: _refreshPage,
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              if (index == 0) {
                _controller.loadRequest(Uri.parse('https://boiache.com/'));
              } else if (index == 1) {
                _controller.loadRequest(
                  Uri.parse('https://boiache.com/cartPage'),
                );
              } else if (index == 2) {
                _controller.loadRequest(
                  Uri.parse('https://boiache.com/dashboard'),
                );
              }
            },
            selectedItemColor: const Color(0xff1C487E),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
