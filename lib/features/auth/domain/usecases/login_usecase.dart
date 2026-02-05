import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../data/models/user_model.dart';

class LoginUseCase extends BaseUseCase<UserModel, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<UserModel, Failure>> call(LoginParams params) async {
    try {
      final user = await repository.login(params.email, params.password);
      return Success(user);
    } catch (e) {
      // In a real app, parse 'e' to return specific Failure
      return Error(ServerFailure(e.toString()));
    }
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}
