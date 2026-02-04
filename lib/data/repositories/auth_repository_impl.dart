import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      return await dataSource.login(email, password);
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dataSource.logout();
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return await dataSource.getCurrentUser();
    } catch (e) {
      return null;
    }
  }
}
