import '../../domain/repositories/bathroom_repository.dart';
import '../datasources/mock_bathroom_datasource.dart';
import '../models/bathroom_entry_model.dart';
import '../models/user_model.dart';

class BathroomRepositoryImpl implements BathroomRepository {
  final MockBathroomDataSource dataSource;

  BathroomRepositoryImpl(this.dataSource);

  @override
  Stream<List<BathroomEntryModel>> getQueue() {
    return dataSource.queueStream;
  }

  @override
  Stream<bool> isOccupiedStream() {
    return dataSource.isOccupiedStream;
  }

  @override
  List<BathroomEntryModel> get currentQueue => dataSource.queue;

  @override
  bool get isOccupied => dataSource.isOccupied;

  @override
  UserModel? getCurrentUser() {
    return dataSource.currentUser;
  }

  @override
  Future<void> joinQueue(UserModel user) {
    return dataSource.joinQueue(user);
  }

  @override
  Future<void> leaveQueue(UserModel user) {
    return dataSource.leaveQueue(user);
  }

  @override
  Future<void> enterBathroom(UserModel user) {
    return dataSource.enterBathroom(user);
  }

  @override
  Future<void> finishBathroom() {
    return dataSource.finishBathroom();
  }
}
