import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_widjet/Data/yotubeAudioDownload.dart';
import 'package:flutter_application_widjet/Screen/Home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

int fileSize = 0;

class _MainAppState extends State<MainApp> {
  late HomeBloc bloc;
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
          if (this.url.startsWith('https://m.youtube.com/watch') ||
              (this.url.startsWith('https://music.youtube.com/watch'))) {
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
      ..loadRequest(Uri.parse('https://www.youtube.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        bloc = HomeBloc(youtubeDownloader);
        return bloc;
      },
      child: MaterialApp(
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
                          onPressed: () => _controller.reload(),
                          icon: const Icon(Icons.refresh)),
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
      ),
    );
  }
}

class ShowDownloadButton extends StatefulWidget {
  const ShowDownloadButton({super.key, required this.url});

  final String url;

  @override
  State<ShowDownloadButton> createState() => _ShowDownloadButtonState();
}

class _ShowDownloadButtonState extends State<ShowDownloadButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                              List<String> urls = widget.url.split('#');
                              youtubeDownloader.downloadAudio(urls[0]);
                              Navigator.pop(context);
                            },
                            child: const Text('Mp3')),
                        TextButton(
                          onPressed: () async {
                            List<String> urls = widget.url.split('#');
                            BlocProvider.of<HomeBloc>(context)
                                .add(BtnVideoDownloadClick(url: urls[0]));
                            //  youtubeDownloader.downloadVideo(urls[0]);
                            // Navigator.pop(context);
                          },
                          child: const Text('MP4'),
                        ),
                      ],
                    )),
              );
            });
      },
      child: const Icon(Icons.download),
    );
  }
}
