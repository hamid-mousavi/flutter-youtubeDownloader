import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_widjet/Data/yotubeDownload.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final WebViewController _controller = WebViewController();
  double progress = 0;
  String url = '';
  bool showDownloadButton = false;
  @override
  void initState() {
    super.initState();
    _controller
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          return NavigationDecision.navigate;
        },
        onProgress: (p) => setState(() {
          progress = p / 100;
        }),
        onPageFinished: (url) => setState(() {
          progress = 0;
          this.url = url;
          if (this.url.startsWith('https://m.youtube.com/watch')) {
            showDownloadButton = true;
          } else {
            showDownloadButton = false;
          }
        }),
        onPageStarted: (url) => setState(() {
          this.url = url;
        }),
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://google.com'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            Column(
              children: [
                //Text(url),
                if (progress > 0 && progress < 1)
                  LinearProgressIndicator(
                    backgroundColor: Colors.green.withOpacity(0.4),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                    value: progress,
                  ),
                Expanded(child: WebViewWidget(controller: _controller)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => _controller.goBack(),
                        icon: const Icon(Icons.arrow_back)),
                    IconButton(
                        onPressed: () => _controller.clearCache(),
                        icon: const Icon(Icons.cached)),
                    IconButton(
                        onPressed: () => _controller.goForward(),
                        icon: const Icon(Icons.arrow_forward)),
                  ],
                ),
              ],
            ),
            showDownloadButton
                ? Positioned(
                    right: 20,
                    bottom: 100,
                    child: ShowDownloadButton(
                      url: url,
                    ))
                : const Text(''),
          ],
        )),
      ),
    );
  }
}

class ShowDownloadButton extends StatelessWidget {
  const ShowDownloadButton({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Select one'),
                content: Container(
                    height: 100.0, // Change as per your requirement
                    width: 100.0, // Change as per your requirement
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              List<String> urls = url.split('#');

                              youtubeDownloader.download(urls[0]);
                              Navigator.pop(context);
                            },
                            child: Text('Mp3, Size: 25M')),
                        TextButton(
                            onPressed: () {
                              youtubeDownloader.download(url);
                              Navigator.pop(context);
                            },
                            child: Text('Mp4, Size: 45M')),
                      ],
                    )),
              );
            });
      },
      child: const Icon(Icons.download),
    );
  }
}

class ShowDownlodType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text('Select one'),
      content: ListTile(
        title: Text('data'),
      ),
    );
  }
}
