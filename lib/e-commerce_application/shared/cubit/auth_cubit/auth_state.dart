part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class LoginLoading extends AuthState{}
class LoginSuccessfully extends AuthState{
  final LoginResponseModel model;
  LoginSuccessfully({required this.model});
}
class LoginWithError extends AuthState{
  final String message;
  LoginWithError({required this.message});
}

class RegisterLoading extends AuthState{}
class RegisterSuccessfully extends AuthState{
final LoginResponseModel model;
RegisterSuccessfully({required this.model});
}
class RegisterWithError extends AuthState{
  final String message;
  RegisterWithError({required this.message});
}
