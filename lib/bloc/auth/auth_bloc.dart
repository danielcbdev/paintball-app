import 'package:firebase_analytics/firebase_analytics.dart';
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
        await FirebaseAnalytics.instance.logEvent(
          name: "login_event",
          parameters: {
            "email": event.email,
          },
        );
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
    on<RegisterUserEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        await authRepository.registerUser(
          name: event.name,
          phone: event.phone,
          cpf: event.cpf,
          email: event.email,
          password: event.password,
        );
        await FirebaseAnalytics.instance.logEvent(
          name: "register_event",
          parameters: {
            "email": event.email,
          },
        );
        emit(DoneRegisterUserState());
      } on AuthException catch (e) {
        emit(ErrorAuthState(message: e.toString()));
      } catch (e) {
        emit(ErrorAuthState(message: e.toString()));
      }
    });
  }
}
