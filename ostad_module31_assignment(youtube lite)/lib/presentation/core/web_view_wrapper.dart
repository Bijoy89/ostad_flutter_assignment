import 'package:flutter/material.dart';
import 'package:ostad_module31_assignment/presentation/core/full_screen_loading_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';


class WebViewWrapper extends StatefulWidget {
  const WebViewWrapper({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<WebViewWrapper> createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends State<WebViewWrapper> {
  late final WebViewController _controller;
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(

          onPageStarted: (_) => _isLoading.value = true,
          onPageFinished: (_) {
            _isLoading.value = false;
            //chrome a inspect a giye navbar ta variable name niye oita arkm kre diye rmv krte parba same for yt appbar
            _controller.runJavaScript('''
            var navBar =document.querySelector('ytm-pivot-bar-renderer');
            if(navBar) navBar.style.display ='none';
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isLoading.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        return FullScreenLoadingOverlay(
          isLoading: isLoading,
          loadingWidget: CircularProgressIndicator(color: AppColors.youtubePrimary,),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios),
              ),
              title: Text(widget.title,style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,

              ),
              ),
            ),
            body: WebViewWidget(controller: _controller),
          ),
        );
      },
    );
  }
}
