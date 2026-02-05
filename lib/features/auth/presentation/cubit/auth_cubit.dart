import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../data/models/user_model.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final result = await getCurrentUserUseCase(NoParams());

    if (result is Success) {
      final user = (result as Success<UserModel?, dynamic>).value;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    // Using strict type check for Result
    if (result is Success<UserModel, dynamic>) {
      emit(AuthAuthenticated((result as Success<UserModel, dynamic>).value));
    } else if (result is Error<UserModel, dynamic>) {
      // Assuming generic Error class has a message or failure props
      // For now, simpler error handling
      emit(const AuthError('Login Failed'));
    }
  }

  Future<void> logout() async {
    final result = await logoutUseCase(NoParams());
    if (result is Success) {
      emit(const AuthUnauthenticated());
    } else {
      emit(const AuthError('Logout Failed'));
    }
  }

  UserModel? getCurrentUser() {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user;
    }
    return null;
  }
}
