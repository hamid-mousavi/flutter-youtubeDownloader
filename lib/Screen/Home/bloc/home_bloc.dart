import 'package:bloc/bloc.dart';
import 'package:flutter_application_widjet/Data/yotubeAudioDownload.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final YoutubeDownloader downloader;
  HomeBloc(this.downloader) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is BtnVideoDownloadClick) {
        emit(DownloadLoading());
        try {
          await downloader.downloadVideo(event.url);
          emit(DownloadSuccess());
        } catch (e) {
          emit(DownloadError(error: e.toString()));
        }
      }
    });
  }
}
