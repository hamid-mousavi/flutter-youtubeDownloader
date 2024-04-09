import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_widjet/main.dart';
import 'package:path/path.dart' as path;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final YoutubeDownloader youtubeDownloader = YoutubeDownloader();

class YoutubeDownloader {
  final yt = YoutubeExplode();

  Future<void> downloadAudio(String id) async {
    final video = await yt.videos.get(id);
    await Permission.storage.request();

    // Get the streams manifest and the audio track.
    final manifest = await yt.videos.streamsClient.getManifest(id);
    final audio = manifest.audioOnly.last;

    // Build the directory.
    final dir = await DownloadsPath.downloadsDirectory();
    final filePath = path.join(
      dir!.uri.toFilePath(),
      '${video.id}.${audio.container.name}',
    );
    final file = File('$filePath.mp3');
    final fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    await yt.videos.streamsClient.get(audio).pipe(fileStream);
    /*
                  If you want to show a % of download, you should listen
                  to the stream instead of using `pipe` and compare
                  the current downloaded streams to the totalBytes,
                  see an example ii example/video_download.dart
                   */

    // Close the file.
    await fileStream.flush();
    await fileStream.close();
  }

  Future<void> downloadVideo(String id) async {
    final video = await yt.videos.get(id);
    await Permission.storage.request();

    // Get the streams manifest and the audio track.
    final manifest = await yt.videos.streamsClient.getManifest(id);
    final videoManifest = manifest.video.first;
    int len = videoManifest.size.totalBytes;
    var received = 0;
    // Build the directory.
    final dir = await DownloadsPath.downloadsDirectory();
    final filePath = path.join(
      dir!.uri.toFilePath(),
      '${video.id}.${videoManifest.container.name}',
    );
    final file = File(filePath);
    final fileStream = file.openWrite();
    // Listen for data received.

    // Pipe all the content of the stream into our file.
    await yt.videos.streamsClient.get(videoManifest).map((event) {
      received += event.length;

      debugPrint("${(received / len) * 100} %");

      return event;
    }).pipe(fileStream);
    /*
                  If you want to show a % of download, you should listen
                  to the stream instead of using `pipe` and compare
                  the current downloaded streams to the totalBytes,
                  see an example ii example/video_download.dart
                   */
    // Listen for data received.

    // Close the file.
    await fileStream.flush();
    await fileStream.close();
  }
}
