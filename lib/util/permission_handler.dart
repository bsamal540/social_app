import 'package:permission_handler/permission_handler.dart';

class PermissionHandler{
  static Future<bool> checkStorageAccess() async {
    PermissionStatus result;
    result = await Permission.storage.status;
    if (result.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else if (result.isDenied) {
      result = await Permission.storage.request();
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkCameraAccess() async {
    PermissionStatus result;
    result = await Permission.camera.status;
    if (result.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else if (result.isDenied) {
      result = await Permission.camera.request();
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkPhotoAccess() async {
    PermissionStatus result;
    result = await Permission.photos.status;
    if (result.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else if (result.isDenied) {
      result = await Permission.photos.request();
      return false;
    } else {
      return true;
    }
  }
}