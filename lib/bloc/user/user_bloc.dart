import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_event.dart';
import 'package:picospaintballzone/bloc/user/user_state.dart';
import 'package:picospaintballzone/infrastructure/user/user_repository.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(InitialUserState()) {
    final userRepository = UserRepository();
    
    on<GetCurrentUserEvent>((event, emit) async {
      emit(LoadingUserState());
      try {
        final user = await userRepository.getCurrentUser();
        if(user != null){
          emit(DoneGetUserState(user: user));
        } else{
          emit(ErrorUserState(message: 'Erro ao buscar usuário, tente novamente mais tarde!'));
        }
      } on UserException catch (e) {
        emit(ErrorUserState(message: e.message));
      } catch (e) {
        emit(ErrorUserState(message: e.toString()));
      }
    });
    on<AddPointToUserEvent>((event, emit) async {
      emit(LoadingUserState());
      try {
        await userRepository.addPointToUser(uidUser: event.uidUser, newQtdPoints: event.newQtdPoints,);
        emit(DoneAddPointToUserState());
      } on UserException catch (e) {
        emit(ErrorUserState(message: e.message));
      } catch (e) {
        emit(ErrorUserState(message: e.toString()));
      }
    });
  }
}
