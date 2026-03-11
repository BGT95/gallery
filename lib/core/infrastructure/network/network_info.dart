import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webant_gallery/core/utils/logger.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) return false;

    try {
      final addresses = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
    } on SocketException {
      AppLogger.warning('Network interface up but no internet access');
      return false;
    } on TimeoutException {
      AppLogger.warning('Internet check timed out');
      return false;
    }
  }
}
