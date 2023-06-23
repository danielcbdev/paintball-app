import 'package:firebase_analytics/firebase_analytics.dart';
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
          await FirebaseAnalytics.instance.logEvent(
            name: "get_current_user",
            parameters: {
              "name": user.name,
              "email": user.email,
            },
          );
          print('registrou!');
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
        await FirebaseAnalytics.instance.logEvent(
          name: "add_point_to_user",
          parameters: {
            "uid_user": event.uidUser,
          },
        );
        emit(DoneAddPointToUserState());
      } on UserException catch (e) {
        emit(ErrorUserState(message: e.message));
      } catch (e) {
        emit(ErrorUserState(message: e.toString()));
      }
    });
  }
}
