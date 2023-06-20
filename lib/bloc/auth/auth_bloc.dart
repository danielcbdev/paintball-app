import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_event.dart';
import 'package:picospaintballzone/bloc/auth/auth_state.dart';
import 'package:picospaintballzone/infrastructure/auth/auth_repository.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    final authRepository = AuthRepository();

    on<LoginEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        await authRepository.login(email: event.email, password: event.password,);
        emit(DoneLoginState());
      } on AuthException catch (e) {
        emit(ErrorAuthState(message: e.message));
      } catch (e) {
        emit(ErrorAuthState(message: e.toString()));
      }
    });
    on<LogoutEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        await authRepository.logout();
        emit(DoneLogoutState());
      } on AuthException catch (e) {
        emit(ErrorAuthState(message: e.toString()));
      } catch (e) {
        emit(ErrorAuthState(message: e.toString()));
      }
    });
  }
}
