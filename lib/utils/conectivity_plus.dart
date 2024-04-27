import 'package:connectivity_plus/connectivity_plus.dart';

Future<String> checkConectivity() async {
    final  connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return "Internet Movíl";
    } else if (connectivityResult == ConnectivityResult.wifi){
      return 'Wifi Conexión';
    }else if (connectivityResult == ConnectivityResult.ethernet){
      return 'Ethernet cable Conexión';
    }
    else if (connectivityResult == ConnectivityResult.vpn){
      return 'Vpn Conexión';
    }
    else if (connectivityResult == ConnectivityResult.bluetooth){
      return 'Bluetooth Conexión';
    }
    else if (connectivityResult == ConnectivityResult.other){
      return 'Otra Conexión';
    }
    else if (connectivityResult == ConnectivityResult.none){
      return 'no hay Conexión';
    }
    return 'No conectado';
  }