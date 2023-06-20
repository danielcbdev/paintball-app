import 'package:equatable/equatable.dart';
import 'package:picospaintballzone/models/user/user.model.dart';

abstract class UserState extends Equatable {}

class InitialUserState extends UserState {
  @override
  List<Object?> get props => [];
}

class LoadingUserState extends UserState {
  @override
  List<Object?> get props => [];
}

class DoneGetUserState extends UserState {
  final UserModel user;

  @override
  List<Object?> get props => [];

  DoneGetUserState({required this.user});
}

class ErrorUserState extends UserState {
  final String message;

  @override
  List<Object?> get props => [];

  ErrorUserState({required this.message});
}
