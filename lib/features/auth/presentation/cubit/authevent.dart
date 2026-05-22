abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested({required this.email, required this.password});
}
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  SignUpRequested({required this.email, required this.password});
}
class SignInWithGoogleRequested extends AuthEvent {}
class SignOutRequested extends AuthEvent {}
class LoginModeToggled extends AuthEvent {}
class PasswordVisibilityToggled extends AuthEvent {}
