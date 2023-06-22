import 'package:equatable/equatable.dart';

abstract class MatchesEvent extends Equatable {}

class GetCurrentMatchEvent extends MatchesEvent {
  @override
  List<Object?> get props => [];
}

class AddPlayerInMatchEvent extends MatchesEvent {
  final String name;

  @override
  List<Object?> get props => [];

  AddPlayerInMatchEvent({required this.name});
}

class AddChargeEvent extends MatchesEvent {
  final int indexUser;
  final double chargeValue;

  @override
  List<Object?> get props => [];

  AddChargeEvent({required this.indexUser, required this.chargeValue});
}

class AddIndividualValueEvent extends MatchesEvent {
  final double individualValue;

  @override
  List<Object?> get props => [];

  AddIndividualValueEvent({required this.individualValue,});
}

class ClearMathEventEvent extends MatchesEvent {
  @override
  List<Object?> get props => [];
}
