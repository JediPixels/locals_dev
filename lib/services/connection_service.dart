import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  static Future<bool> isInternetConnectionAvailable() async {
    bool isConnectionAvailable = await checkConnectivity();
    if (isConnectionAvailable == false) {
      return false;
    }
    return true;
  }

  static Future<bool> checkConnectivity() async {
    bool isInternetConnectionOn = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      isInternetConnectionOn = false;
    }
    return isInternetConnectionOn;
  }
}