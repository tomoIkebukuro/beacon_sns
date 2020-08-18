import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import '../class.dart';

Future<bool> checkLocationPermission() async{
  //ここで位置情報の権限を確認する
  return await Permission.locationWhenInUse.isGranted;
}

Future<bool> requestLocationPermission()async{
  return Permission.contacts.request().isGranted;
}

Future<Null> openAppSettings()async{
  bool isOpened = await openAppSettings();
  if(!isOpened){
    throw Exception("設定画面を開くことができません。");
  }
  return null;
}

Future<Location> getCurrentLocation() async{
  var position= await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return Location(latitude: position.latitude,longitude: position.longitude);
}