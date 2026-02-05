import '../../data/models/bathroom_entry_model.dart';
import '../../data/models/user_model.dart';

abstract class BathroomRepository {
  Stream<List<BathroomEntryModel>> getQueue();
  Stream<bool> isOccupiedStream();

  // Synchronous getters for initial state
  List<BathroomEntryModel> get currentQueue;
  bool get isOccupied;

  UserModel? getCurrentUser();
  Future<void> joinQueue(UserModel user);
  Future<void> leaveQueue(UserModel user);
  Future<void> enterBathroom(UserModel user);
  Future<void> finishBathroom();
}
