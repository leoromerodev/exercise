import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:heavek/utils/enums.dart';

class NetworkConnectivity {
  //singleton instance
  static NetworkConnectivity get instance => NetworkConnectivity();

  StreamController<NetworkStatus> networkStatusStream =
      StreamController<NetworkStatus>();

  //method to check if the device is connected to network
  Future<NetworkStatus> getNetworkStatus() async {
    //initializing ConnectivityResult
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    //checking if the device is connected to cellular or wifi network
    NetworkStatus networkStatus = result.first == ConnectivityResult.mobile ||
            result.first == ConnectivityResult.wifi
        ? NetworkStatus.online
        : NetworkStatus.offline;

    return networkStatus;
  }
}




