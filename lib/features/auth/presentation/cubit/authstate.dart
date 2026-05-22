
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {
final bool isLogin;
final bool obscurePassword;

  AuthState({
    this.isLogin = true,
    this.obscurePassword = true,
  });
}


class AuthInitial extends AuthState{
AuthInitial({super.isLogin, super.obscurePassword});


}
class AuthLoading extends AuthState{
  AuthLoading({super.isLogin, super.obscurePassword});
}
class AuthAuthenticated extends AuthState{
  final User user;
  AuthAuthenticated(this.user, {super.isLogin, super.obscurePassword});
}

class AuthUnauthenticated extends AuthState {
  AuthUnauthenticated({super.isLogin, super.obscurePassword});
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message, {super.isLogin, super.obscurePassword});
}

extension AuthStateExtension on AuthState {
  AuthState copyWith({
    bool? isLogin,
    bool? obscurePassword,
  }) {
    if (this is AuthInitial){
return AuthInitial( 
  isLogin : isLogin?? this.isLogin,
obscurePassword : obscurePassword?? this.obscurePassword);

    }else if(this is AuthLoading){
      return AuthLoading( 
        isLogin: isLogin?? this.isLogin,
        obscurePassword: obscurePassword?? this.obscurePassword);
    }
    else if (this is AuthAuthenticated){
     return AuthAuthenticated((this as AuthAuthenticated).user,
    isLogin: isLogin?? this.isLogin,
    obscurePassword: obscurePassword?? this.obscurePassword);

    


   

    } else if (this is AuthUnauthenticated) {
      return AuthUnauthenticated(
        isLogin: isLogin ?? this.isLogin,
        obscurePassword: obscurePassword ?? this.obscurePassword,
      );
    } else if (this is AuthError) {
      return AuthError(
        (this as AuthError).message,
        isLogin: isLogin ?? this.isLogin,
        obscurePassword: obscurePassword ?? this.obscurePassword,
      );
    }
    return this;
  }
}
final class GoogleSignInSuccess extends AuthState {
}
final class GoogleSignInLoading extends AuthState {
}
final class GoogleSignInError extends AuthState {
}
