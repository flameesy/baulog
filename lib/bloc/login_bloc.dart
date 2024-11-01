import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_events.dart';
import 'login_state.dart';
import '../core/services/service_base.dart'; // Stelle sicher, dass du den richtigen Import hast

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ServiceBase _serviceBase;

  LoginBloc(this._serviceBase) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    // Benutzer authentifizieren
    final isAuthenticated = await _serviceBase.authenticateUser(event.username, event.password);

    if (isAuthenticated) {
      emit(LoginSuccess(message: 'Login erfolgreich!'));
    } else {
      emit(LoginFailure(error: 'Ungültige Anmeldeinformationen'));
    }
  }
}
