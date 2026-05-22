// import 'package:fluttershop/features/camera_permission/data/datasources/permission_data_source.dart';
// import 'package:fluttershop/features/domain/entities/permission_status.dart';
// import 'package:fluttershop/features/domain/repositories/camera_repository.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CameraPermissionRepositoryImpl implements CameraPermissionRepository {
//   final PermissionDataSource dataSource;

//   CameraPermissionRepositoryImpl(this.dataSource);

//   @override
//   Future<CameraPermissionStatus> requestCameraPermission() async {
//     final status = await dataSource.requestCameraPermission();
//     return _mapPermissionStatus(status);
//   }

//   @override
//   Future<CameraPermissionStatus> getCameraPermissionStatus() async {
//     final status = await dataSource.getCameraPermissionStatus();
//     return _mapPermissionStatus(status);
//   }

//   @override
//   Future<void> openAppSettings() async {
//     await dataSource.openAppSettings();
//   }

//   CameraPermissionStatus _mapPermissionStatus(PermissionStatus status) {
//     switch (status) {
//       case PermissionStatus.granted:
//         return CameraPermissionStatus.granted;
//       case PermissionStatus.denied:
//         return CameraPermissionStatus.denied;
//       case PermissionStatus.permanentlyDenied:
//         return CameraPermissionStatus.permanentlyDenied;
//       case PermissionStatus.restricted:
//         return CameraPermissionStatus.restricted;
//       case PermissionStatus.limited:
//         return CameraPermissionStatus.limited;
//       case PermissionStatus.provisional:
//         return CameraPermissionStatus.provisional;
//       default:
//         return CameraPermissionStatus.unknown;
//     }
//   }
// }
