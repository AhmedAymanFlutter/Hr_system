import 'package:hr_system/data/models/user_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase extends BaseUseCase<UserModel, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Result<UserModel, Failure>> call(NoParams params) async {
    try {
      final user = await repository.getCurrentUser();
      return Success(user!);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }
}
