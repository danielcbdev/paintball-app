import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  @override
  List<Object?> get props => [];

  LoginEvent({required this.email, required this.password,});
}

class RegisterUserEvent extends AuthEvent {
  final String name;
  final String phone;
  final String cpf;
  final String email;
  final String password;

  @override
  List<Object?> get props => [];

  RegisterUserEvent({required this.name, required this.phone, required this.cpf, required this.email, required this.password,});
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
