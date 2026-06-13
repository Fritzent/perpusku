import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl(this._connectivity);

  @override
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(
        (results) => !results.contains(ConnectivityResult.none),
      );

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}