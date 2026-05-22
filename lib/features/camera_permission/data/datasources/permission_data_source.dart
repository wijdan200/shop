// import 'package:flutter/foundation.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionDataSource {
//   Future<PermissionStatus> requestCameraPermission() async {
//     try {
//       // debugPrint("[PermissionDataSource] >>Requesting camera permission...");
//       final result = await Permission.camera.request();
//       debugPrint("[PermissionDataSource] >>Request result: $result");
//       return result;
//     } catch (e) {
//       debugPrint(
//         "[PermissionDataSource] >>Error requesting camera permission: $e",
//       );
//       rethrow;
//     }
//   }

//   Future<PermissionStatus> getCameraPermissionStatus() async {
//     try {
//       debugPrint("[PermissionDataSource] Checking camera permission status...");
//       final status = await Permission.camera.status;
//       debugPrint("[PermissionDataSource] Current status: $status");
//       return status;
//     } catch (e) {
//       debugPrint(
//         "[PermissionDataSource] >>Error checking camera permission status: $e",
//       );
//       rethrow;
//     }
//   }

//   Future<bool> openAppSettings() async {
//     try {
//       debugPrint("[PermissionDataSource] Opening app settings...");
//       return await openAppSettings();
//     } catch (e) {
//       debugPrint("[PermissionDataSource] >>Error opening app settings: $e");
//       rethrow;
//     }
//   }
// }
