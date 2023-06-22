import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class InitialAuthState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoadingAuthState extends AuthState {
  @override
  List<Object?> get props => [];
}

class DoneLoginState extends AuthState {
  @override
  List<Object?> get props => [];
}

class DoneLogoutState extends AuthState {
  @override
  List<Object?> get props => [];
}

class DoneRegisterUserState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ErrorAuthState extends AuthState {
  final String message;

  @override
  List<Object?> get props => [];

  ErrorAuthState({required this.message});
}
