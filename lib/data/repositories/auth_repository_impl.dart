import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/mock_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockAuthDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // First try to check remote session if applicable,
      // but for now return local cached user if available
      // In real app: verify token from local storage with API
      final localUser = await localDataSource.getLastUser();

      // Update mock data source state if needed for consistency
      // (This is a bit hacky for Mock but ensures MockDataSource knows who is logged in)
      if (localUser != null) {
        // We assume we can "re-login" to mock data source or it's stateless enough
      }
      return localUser;
    } catch (e) {
      return null;
    }
  }
}
