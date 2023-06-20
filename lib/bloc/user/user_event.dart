import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {}

class GetCurrentUserEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}
