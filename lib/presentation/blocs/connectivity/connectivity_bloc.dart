import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perpusku/core/network/connectivity_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _service;
  StreamSubscription<bool>? _sub;

  ConnectivityBloc(this._service) : super(const ConnectivityState()) {
    on<ConnectivityChanged>(_onChange);
    on<ConnectivityRetry>(_onRetry);
    _subscribe();
  }

  void _subscribe() {
    _sub = _service.onConnectivityChanged.listen(
      (connected) => add(ConnectivityChanged(connected)),
    );
  }

  Future<void> _onChange(
      ConnectivityChanged event, Emitter<ConnectivityState> emit) async {
    emit(state.copyWith(
      isConnected: event.isConnected,
      hasBeenOffline: state.hasBeenOffline || !event.isConnected,
    ));
  }

  Future<void> _onRetry(
      ConnectivityRetry event, Emitter<ConnectivityState> emit) async {
    final connected = await _service.isConnected;
    emit(state.copyWith(isConnected: connected));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
