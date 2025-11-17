// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_curtain_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_curtain_app/features/auth/data/models/login_request_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginRequestModel(email: event.username, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (response) => emit(
        AuthSuccess(
          token: response.token, // hoặc response.token nếu cần
          refreshToken: response.refreshToken,
        ),
      ),
    );
  }
}
