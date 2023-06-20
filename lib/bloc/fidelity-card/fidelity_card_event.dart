import 'package:equatable/equatable.dart';

abstract class FidelityCardEvent extends Equatable {}

class GetFidelityCardConfigEvent extends FidelityCardEvent {
  @override
  List<Object?> get props => [];
}
