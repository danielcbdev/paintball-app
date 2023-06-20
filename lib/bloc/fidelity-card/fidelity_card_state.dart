import 'package:equatable/equatable.dart';
import 'package:picospaintballzone/models/fidelity-card/fidelity_card.model.dart';

abstract class FidelityCardState extends Equatable {}

class InitialFidelityCardState extends FidelityCardState {
  @override
  List<Object?> get props => [];
}

class LoadingFidelityCardState extends FidelityCardState {
  @override
  List<Object?> get props => [];
}

class DoneGetFidelityCardConfigState extends FidelityCardState {
  final FidelityCardConfigModel fidelityCardConfig;

  @override
  List<Object?> get props => [];

  DoneGetFidelityCardConfigState({required this.fidelityCardConfig});
}

class ErrorFidelityCardState extends FidelityCardState {
  final String message;

  @override
  List<Object?> get props => [];

  ErrorFidelityCardState({required this.message});
}
