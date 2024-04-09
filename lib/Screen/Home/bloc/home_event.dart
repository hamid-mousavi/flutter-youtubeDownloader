part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeStarted extends HomeEvent {}

class BtnVideoDownloadClick extends HomeEvent {
  final String url;

  BtnVideoDownloadClick({required this.url});
}
