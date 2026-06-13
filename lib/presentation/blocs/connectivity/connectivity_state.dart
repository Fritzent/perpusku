part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  final bool isConnected;
  final bool hasBeenOffline;

  const ConnectivityState({
    this.isConnected = true,
    this.hasBeenOffline = false,
  });

  ConnectivityState copyWith({bool? isConnected, bool? hasBeenOffline}) =>
      ConnectivityState(
        isConnected: isConnected ?? this.isConnected,
        hasBeenOffline: hasBeenOffline ?? this.hasBeenOffline,
      );

  @override
  List<Object?> get props => [isConnected, hasBeenOffline];
}