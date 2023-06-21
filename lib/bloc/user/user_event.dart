import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {}

class GetCurrentUserEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}

class AddPointToUserEvent extends UserEvent {
  final String uidUser;
  final int newQtdPoints;

  @override
  List<Object?> get props => [];

  AddPointToUserEvent({required this.uidUser, required this.newQtdPoints});
}
