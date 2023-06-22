import 'package:equatable/equatable.dart';
import 'package:picospaintballzone/models/match/match.model.dart';

abstract class MatchesState extends Equatable {}

class InitialMatchesState extends MatchesState {
  @override
  List<Object?> get props => [];
}

class DoneGetCurrentMatchState extends MatchesState {
  final MatchModel? match;

  @override
  List<Object?> get props => [];

  DoneGetCurrentMatchState({required this.match});
}

class DoneUpdateCurrentMatchState extends MatchesState {
  final MatchModel? match;

  @override
  List<Object?> get props => [];

  DoneUpdateCurrentMatchState({required this.match});
}

class EmptyMatchesState extends MatchesState {
  @override
  List<Object?> get props => [];
}

class ErrorMatchesState extends MatchesState {
  final String message;

  @override
  List<Object?> get props => [];

  ErrorMatchesState({required this.message});
}
