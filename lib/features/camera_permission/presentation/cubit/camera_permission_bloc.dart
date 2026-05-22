// import 'package:bloc/bloc.dart';
// import 'package:fluttershop/features/camera_permission/domain/usecases/get_permission_status_usecase.dart';
// import 'package:fluttershop/features/camera_permission/domain/usecases/open_app_settings_usecase.dart';
// import 'package:fluttershop/features/camera_permission/domain/usecases/request_permission_usecase.dart';
// import 'package:fluttershop/features/camera_permission/presentation/cubit/camera_permission_event.dart';
// import 'package:fluttershop/features/camera_permission/presentation/cubit/camera_permission_state.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class CameraPermissionBloc
//     extends Bloc<CameraPermissionEvent, CameraPermissionState> {
//   final GetPermissionStatusUseCase getPermissionStatusUseCase;
//   final RequestCameraPermissionUseCase requestCameraPermissionUseCase;
//   final OpenAppSettingsUseCase openAppSettingsUseCase;

//   CameraPermissionBloc({
//     required this.getPermissionStatusUseCase,
//     required this.requestCameraPermissionUseCase,
//     required this.openAppSettingsUseCase,
//   }) : super(CameraPermissionInitial()) {
//     on<CheckCameraPermission>(_onCheckPermission);
//     on<RequestCameraPermission>(_onRequestPermission);
//     on<OpenAppSettings>(_onOpenAppSettings);
//   }

//   Future<void> _onCheckPermission(
//     CheckCameraPermission event,
//     Emitter<CameraPermissionState> emit,
//   ) async {
//     try {
//       debugPrint("[CameraPermissionBloc] >>_onCheckPermission triggered");
//       emit(CameraPermissionLoading());
//       final status = await getPermissionStatusUseCase();
//       debugPrint("[CameraPermissionBloc] Permission status checked: $status");
//       emit(CameraPermissionChecked(status));
//     } catch (e) {
//       debugPrint("[CameraPermissionBloc] >>Error in _onCheckPermission: $e");
//       // Optionally emit an error state here if you had one
//     }
//   }

//   Future<void> _onRequestPermission(
//     RequestCameraPermission event,
//     Emitter<CameraPermissionState> emit,
//   ) async {
//     try {
//       debugPrint("[CameraPermissionBloc] _onRequestPermission triggered");
//       emit(CameraPermissionLoading());
//       final status = await requestCameraPermissionUseCase();
//       debugPrint(
//         "[CameraPermissionBloc] Permission requested. Result: $status",
//       );
//       emit(CameraPermissionChecked(status));
//     } catch (e) {
//       debugPrint("[CameraPermissionBloc] >>Error in _onRequestPermission: $e");
//     }
//   }

//   Future<void> _onOpenAppSettings(
//     OpenAppSettings event,
//     Emitter<CameraPermissionState> emit,
//   ) async {
//     try {
//       debugPrint("[CameraPermissionBloc] _onOpenAppSettings triggered");
//       await openAppSettingsUseCase();
//       debugPrint("[CameraPermissionBloc] App settings opened");
//     } catch (e) {
//       debugPrint("[CameraPermissionBloc] >>Error in _onOpenAppSettings: $e");
//     }
//   }
// }
