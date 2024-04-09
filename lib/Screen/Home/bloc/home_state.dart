part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class DownloadLoading extends HomeState {}

final class DownloadSuccess extends HomeState {}

final class DownloadError extends HomeState {
  final String error;

  DownloadError({required this.error});
}
