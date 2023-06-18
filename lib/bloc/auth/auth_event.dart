import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  @override
  List<Object?> get props => [];

  LoginEvent({required this.email, required this.password,});
}
