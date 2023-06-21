import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_event.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_state.dart';
import 'package:picospaintballzone/infrastructure/fidelity-card/fidelity_card_repository.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class FidelityCardBloc extends Bloc<FidelityCardEvent, FidelityCardState> {
  FidelityCardBloc() : super(InitialFidelityCardState()) {
    final fidelityCardRepository = FidelityCardRepository();
    
    on<GetFidelityCardConfigEvent>((event, emit) async {
      emit(LoadingFidelityCardState());
      try {
        final fidelityCardConfig = await fidelityCardRepository.getFidelityCardConfig();
        if(fidelityCardConfig != null){
          emit(DoneGetFidelityCardConfigState(fidelityCardConfig: fidelityCardConfig));
        } else{
          emit(ErrorFidelityCardState(message: 'Erro ao buscar as informações, tente novamente mais tarde!'));
        }
      } on FidelityCardException catch (e) {
        emit(ErrorFidelityCardState(message: e.message));
      } catch (e) {
        emit(ErrorFidelityCardState(message: e.toString()));
      }
    });
  }
}
