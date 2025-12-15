// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BoiAcheWebViewApp extends StatefulWidget {
  const BoiAcheWebViewApp({super.key});

  @override
  State<BoiAcheWebViewApp> createState() => _BoiAcheWebViewAppState();
}

class _BoiAcheWebViewAppState extends State<BoiAcheWebViewApp> {
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
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'BoiAche',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                ListTile(
                  title: const Text('Home'),
                  onTap: () => _controller.loadRequest(
                    Uri.parse('https://boiache.com/'),
                  ),
                ),
                ListTile(
                  title: const Text('Cart'),
                  onTap: () => _controller.loadRequest(
                    Uri.parse('https://boiache.com/cartPage'),
                  ),
                ),
                ListTile(
                  title: const Text('Account'),
                  onTap: () => _controller.loadRequest(
                    Uri.parse('https://boiache.com/dashboard'),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: _isDarkMode,
                  onChanged: (v) => setState(() => _isDarkMode = v),
                ),
              ],
            ),
          ),
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
            onTap: (index) {
              if (index == 0) {
                _controller.loadRequest(Uri.parse('https://boiache.com/'));
              } else if (index == 1) {
                _controller.loadRequest(
                  Uri.parse('https://boiache.com/cartPage'),
                );
              } else {
                _controller.loadRequest(
                  Uri.parse('https://boiache.com/dashboard'),
                );
              }
            },
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
