import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_event.dart';
import 'package:picospaintballzone/bloc/auth/auth_state.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    // final chargeRepository = AuthRepository();

    on<LoginEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        // final result = await chargeRepository.generatePaymentSlip(code: event.code);
        // emit(DoneAuthState(
        //   urlPaymentSlip: result,
        //   code: event.code,
        // ));
      } on AuthException catch (e) {
        emit(ErrorAuthState(message: e.message));
      } catch (e) {
        emit(ErrorAuthState(message: e.toString()));
      }
    });
  }
}
