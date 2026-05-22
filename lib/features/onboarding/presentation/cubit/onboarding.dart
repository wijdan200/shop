import 'package:flutter_bloc/flutter_bloc.dart';

// State
abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

// Cubit
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());
}
